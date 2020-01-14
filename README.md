# terraform-aws-s3logging-bucket
[![](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/workflows/check/badge.svg)](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions)

Create and manage a bucket suitable for access logging for other S3 buckets.

## Usage
```
module "s3logging-bucket" {
  source        = "git::https://github.com/rhythmictech/terraform-aws-s3logging-bucket"
  region        = var.region
  bucket_suffix = "account"
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket\_suffix |  | string | n/a | yes |
| region |  | string | n/a | yes |
| tags | Mapping of any extra tags you want added to resources | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3logging\_bucket\_arn | The ARN of the bucket |
| s3logging\_bucket\_name | The name of the bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
