data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

locals {
  account_id  = data.aws_caller_identity.current.account_id
  bucket_name = var.bucket_name == null ? "${local.account_id}-${local.region}-s3logging-${var.bucket_suffix}" : var.bucket_name
  region      = data.aws_region.current.name
}

# Ignore logging requirement - access logging for a logging bucket is a little meta
#tfsec:ignore:AWS002
resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  acl    = "log-delivery-write"
  tags   = var.tags

  dynamic "lifecycle_rule" {
    iterator = rule
    for_each = var.lifecycle_rules

    content {
      id      = rule.value.id
      enabled = rule.value.enabled
      prefix  = lookup(rule.value, "prefix", null)

      expiration {
        days = lookup(rule.value, "expiration", 2147483647)
      }

      noncurrent_version_expiration {
        days = lookup(rule.value, "noncurrent_version_expiration", 365)
      }
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  versioning {
    enabled    = var.versioning_enabled
    mfa_delete = var.mfa_delete_enabled
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
