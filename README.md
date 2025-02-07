# terraform-aws-s3logging-bucket
[![tflint](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions/workflows/tflint.yaml/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![tfsec](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions/workflows/tfsec.yaml/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions/workflows/yamllint.yaml/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions/workflows/misspell.yaml/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions/workflows/pre-commit.yaml/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-s3logging-bucket/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
![X (formerly Twitter) Follow](https://img.shields.io/twitter/follow/RhythmicTech)


Create and manage a bucket suitable for access logging for other S3 buckets.


## Usage
Basic usage:
```
module "s3logging-bucket" {
  source = "rhythmictech/s3logging-bucket/aws"
}
```

Combine with other S3-based modules, like our cloudtrail bucket module:
```
module "s3logging-bucket" {
  source = "rhythmictech/s3logging-bucket/aws"
  version = "3.3.0"
}

module "cloudtrail-bucket" {
  source         = "git::https://github.com/rhythmictech/terraform-aws-cloudtrail-bucket?ref=v4.0.0"

  logging_bucket      = module.s3logging-bucket.s3_bucket_name
  region              = var.region
}

module "cloudtrail-logging" {
  source            = "git::https://github.com/rhythmictech/terraform-aws-cloudtrail-logging?ref=v1.3.0"

  cloudtrail_bucket = module.cloudtrail-bucket.s3_bucket_name
  kms_key_id        = module.cloudtrail-bucket.kms_key_id
  region            = var.region
}
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.70.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.70.0, < 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name to apply to bucket (use `bucket_name` or `bucket_suffix`) | `string` | `null` | no |
| <a name="input_bucket_suffix"></a> [bucket\_suffix](#input\_bucket\_suffix) | Suffix to apply to the bucket (use `bucket_name` or `bucket_suffix`). When using `bucket_suffix`, the bucket name will be `[account_id]-[region]-s3logging-[bucket_suffix].` | `string` | `"default"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key to encrypt bucket with. | `string` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | lifecycle rules to apply to the bucket | <pre>list(object(<br>    {<br>      id                            = string<br>      enabled                       = optional(bool, true)<br>      expiration                    = optional(number)<br>      prefix                        = optional(string)<br>      noncurrent_version_expiration = optional(number)<br>      transition = optional(list(object({<br>        days          = number<br>        storage_class = string<br>      })))<br>  }))</pre> | <pre>[<br>  {<br>    "id": "expire-noncurrent-objects-after-ninety-days",<br>    "noncurrent_version_expiration": 90<br>  },<br>  {<br>    "id": "transition-to-IA-after-30-days",<br>    "transition": [<br>      {<br>        "days": 30,<br>        "storage_class": "STANDARD_IA"<br>      }<br>    ]<br>  },<br>  {<br>    "expiration": 2557,<br>    "id": "delete-after-seven-years"<br>  }<br>]</pre> | no |
| <a name="input_lifecycle_transition_default_minimum_object_size"></a> [lifecycle\_transition\_default\_minimum\_object\_size](#input\_lifecycle\_transition\_default\_minimum\_object\_size) | The default minimum object size behavior applied to the lifecycle configuration | `string` | `"varies_by_storage_class"` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Specifies S3 object ownership control. Defaults to BucketOwnerPreferred for backwards-compatibility. Recommended value is BucketOwnerEnforced. | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to supported resources | `map(string)` | `{}` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Whether or not to use versioning on the bucket. This can be useful for audit purposes since objects in a logging bucket should not be updated. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the bucket |
| <a name="output_s3_bucket_domain_name"></a> [s3\_bucket\_domain\_name](#output\_s3\_bucket\_domain\_name) | The domain name of the bucket |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The name of the bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## History
Between versions 1.x and 2.x, there were breaking changes. In particular, resource names were changed to follow a `this` convention. The following commands (with some customization for naming) will automatically migrate existing states:

```
terraform state mv module.s3logging-bucket.aws_s3_bucket.s3logging_bucket module.s3logging-bucket.aws_s3_bucket.this
terraform state mv module.s3logging-bucket.aws_s3_bucket_public_access_block.block_public_access module.s3logging-bucket.aws_s3_bucket_public_access_block.this
```

The `region` var was also been removed.
