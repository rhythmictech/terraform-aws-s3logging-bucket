variable "bucket_name" {
  default     = null
  description = "Name to apply to bucket (use `bucket_name` or `bucket_suffix`)"
  type        = string
}

variable "bucket_suffix" {
  default     = "default"
  description = "Suffix to apply to the bucket (use `bucket_name` or `bucket_suffix`). When using `bucket_suffix`, the bucket name will be `[account_id]-[region]-s3logging-[bucket_suffix]."
  type        = string
}

variable "kms_key_id" {
  default     = null
  description = "KMS key to encrypt bucket with."
  type        = string
}

variable "lifecycle_rules" {
  description = "lifecycle rules to apply to the bucket"

  default = [
    {
      id                            = "expire-noncurrent-objects-after-ninety-days"
      noncurrent_version_expiration = 90
    },
    {
      id = "transition-to-IA-after-30-days"
      transition = [{
        days          = 30
        storage_class = "STANDARD_IA"
      }]
    },
    {
      id         = "delete-after-seven-years"
      expiration = 2557
    },
  ]

  type = list(object(
    {
      id                            = string
      enabled                       = optional(bool, true)
      expiration                    = optional(number)
      prefix                        = optional(string)
      noncurrent_version_expiration = optional(number)
      transition = optional(list(object({
        days          = number
        storage_class = string
      })))
  }))
}

variable "lifecycle_transition_default_minimum_object_size" {
  default     = "varies_by_storage_class"
  description = "The default minimum object size behavior applied to the lifecycle configuration"
  type        = string
}

variable "object_ownership" {
  default     = "BucketOwnerEnforced"
  description = "Specifies S3 object ownership control. With the default (and recommended) value of `BucketOwnerEnforced`, ACLs are disabled and log delivery is granted via bucket policy instead of the `log-delivery-write` ACL."
  type        = string

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership must be one of BucketOwnerEnforced, BucketOwnerPreferred, or ObjectWriter."
  }
}

variable "reset_bucket_acl" {
  default     = false
  description = "Set to true when migrating an existing bucket that has ACLs applied (e.g. `log-delivery-write` from an earlier module version) to `object_ownership = \"BucketOwnerEnforced\"`. Resets the bucket ACL to `private` before ownership controls disable ACLs, as AWS requires. Leave false for new buckets — ACL requests fail on buckets that are already BucketOwnerEnforced."
  type        = bool
}

variable "tags" {
  default     = {}
  description = "Tags to add to supported resources"
  type        = map(string)
}

variable "versioning_enabled" {
  default     = true
  description = "Whether or not to use versioning on the bucket. This can be useful for audit purposes since objects in a logging bucket should not be updated."
  type        = bool
}
