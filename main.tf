data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  bucket_name = coalesce(
    var.bucket_name,
    "${local.account_id}-${local.region}-s3logging-${var.bucket_suffix}"
  )

  region = data.aws_region.current.name
}

# Ignore logging requirement - access logging for a logging bucket is a little meta
#tfsec:ignore:AWS002
resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "this" {
  count = var.object_ownership == "BucketOwnerEnforced" ? 0 : 1

  bucket = aws_s3_bucket.this.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  bucket                                 = aws_s3_bucket.this.id
  transition_default_minimum_object_size = var.lifecycle_transition_default_minimum_object_size

  dynamic "rule" {
    iterator = rule
    for_each = var.lifecycle_rules

    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      filter {
        prefix = try(rule.value.prefix, null)
      }

      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [1] : [0]

        content {
          days = rule.value.expiration
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? [1] : []

        content {
          noncurrent_days = rule.value.noncurrent_version_expiration
        }
      }

      dynamic "transition" {
        for_each = coalesce(rule.value.transition, [])

        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = var.kms_key_id != null ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.versioning_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = var.object_ownership == "BucketOwnerEnforced" ? 1 : 0

  bucket = aws_s3_bucket.this.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3ServerAccessLogsPolicy",
            "Effect": "Allow",
            "Principal": {
                "Service": "logging.s3.amazonaws.com"
            },
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${local.account_id}"
                }
            }
        }
    ]
}
EOF
}
