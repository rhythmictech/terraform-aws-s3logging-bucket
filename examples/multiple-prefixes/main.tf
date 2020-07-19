module "s3logging-bucket" {
  source = "../.."

  bucket_suffix = "system"

  lifecycle_rules = [{
    id      = "cloudtrail-expire"
    enabled = true
    prefix  = "1111111111111-us-east-1-cloudtrail"

    # keep all cloudtrail logs for 5 years
    expiration                    = 1825
    noncurrent_version_expiration = 1825
    },

    {
      id      = "vpcflowlog-expire"
      enabled = true
      prefix  = "1111111111111-us-east-1-vpcflowlog"

      # keep flow logs for 90 days
      expiration                    = 90
      noncurrent_version_expiration = 90
    },

    {
      id      = "tfstate-expire"
      enabled = true
      prefix  = "tfstate-s3-logs"

      # keep logs for tfstate access for 5 years
      expiration                    = 1825
      noncurrent_version_expiration = 1825
  }]

  tags = {
    terraform_managed = true
    owner             = "IT Operations"
  }
}
