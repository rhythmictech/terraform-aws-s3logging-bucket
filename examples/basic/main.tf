module "s3logging-bucket" {
  source = "../.."

  bucket_suffix = "system"

  tags = {
    terraform_managed = true
    owner             = "IT Operations"
  }
}
