variable "bucket_name" {
  default     = null
  description = "Name to apply to bucket (use `bucket_name` or `bucket_suffix`)"
  type        = string
}

variable "bucket_suffix" {
  default     = "default"
  description = "Suffix to apply to the bucket (use `bucket_name` or `bucket_suffix`). When using `bucket_suffix`, the bucket name will be `[ACCOUNT_ID]-[REGION]-s3logging-[BUCKET_SUFFIX]."
  type        = string
}

variable "lifecycle_rules" {
  default = [{
    id                            = "expire"
    enabled                       = true
    prefix                        = null
    expiration                    = 2147483647
    noncurrent_version_expiration = 365
  }]

  description = "lifecycle rules to apply to the bucket"

  type = list(object(
    {
      id                            = string
      enabled                       = bool
      prefix                        = string
      expiration                    = number
      noncurrent_version_expiration = number
  }))
}

variable "mfa_delete_enabled" {
  default     = null
  description = "enable MFA delete on the bucket (note that this cannot be enabled programatically and requires the root account)"
  type        = bool
}

# tflint-ignore: terraform_unused_declarations
variable "region" {
  default     = null
  description = "(deprecated) this variable is no longer used and will be removed in a future release"
  type        = string
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
