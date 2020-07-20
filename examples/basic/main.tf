module "s3logging-bucket" {
  source = "../.."

  bucket_suffix = "system"

  # store logs for 1 year
  lifecycle_rules = [{
    id                            = "expire"
    enabled                       = true
    prefix                        = null
    expiration                    = 365
    noncurrent_version_expiration = 365
  }]

  tags = {
    terraform_managed = true
    owner             = "IT Operations"
  }
}
