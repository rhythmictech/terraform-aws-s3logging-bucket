# terraform-aws-s3logging-bucket
[![](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/workflows/check/badge.svg)](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions)

Create and manage a bucket suitable for access logging for other S3 buckets.

Note that due to the way S3 pricing works on IA and Glacier tiers, this module does not support automatic transition policies in the lifecycle rules. It is always cheaper to store ELB access logs in the standard tier.

## Usage
```
module "s3logging-bucket" {
  source        = "rhythmictech/s3logging-bucket/aws"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.19 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | Name to apply to bucket (use `bucket_name` or `bucket_suffix`) | `string` | `null` | no |
| bucket\_suffix | Suffix to apply to the bucket (use `bucket_name` or `bucket_suffix`). When using `bucket_suffix`, the bucket name will be `[account_id]-[region]-s3logging-[bucket_suffix].` | `string` | `"default"` | no |
| lifecycle\_rules | lifecycle rules to apply to the bucket | <pre>list(object(<br>    {<br>      id                            = string<br>      enabled                       = bool<br>      prefix                        = string<br>      expiration                    = number<br>      noncurrent_version_expiration = number<br>  }))</pre> | `[]` | no |
| tags | Tags to add to supported resources | `map(string)` | `{}` | no |
| versioning\_enabled | Whether or not to use versioning on the bucket. This can be useful for audit purposes since objects in a logging bucket should not be updated. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3\_bucket\_arn | The ARN of the bucket |
| s3\_bucket\_domain\_name | The domain name of the bucket |
| s3\_bucket\_name | The name of the bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## History
Between versions 1.x and 2.x, there were breaking changes. In particular, resource names were changed to follow a `this` convention. The following commands (with some customization for naming) will automatically migrate existing states:

```
terraform state mv module.s3logging-bucket.aws_s3_bucket.s3logging_bucket module.s3logging-bucket.aws_s3_bucket.this
terraform state mv module.s3logging-bucket.aws_s3_bucket_public_access_block.block_public_access module.s3logging-bucket.aws_s3_bucket_public_access_block.this
```

The `region` var was also been removed.
