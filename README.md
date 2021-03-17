## Usage

Creates an IAM policy that allows use of AWS Athena.

```hcl
module "athena_iam_policy" {
  source = "dod-iac/athena-iam-policy/aws"

  databases = [aws_glue_catalog_database.main.arn]
  name = format("%s-athena-user-%s", var.application, var.environment)
  result_buckets = [aws_s3_bucket.results.arn]
  require_mfa = true
  source_buckets = [aws_s3_bucket.source.arn]
  source_keys = ["*"]
  workgroups = [aws_athena_workgroup.main.arn]
}
```

## Terraform Version

Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform 0.11 and 0.12 are not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 2.55.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.55.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_iam_account_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_account_alias) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| databases | The ARNs of the databases that can be used.  Use ["*"] to allow all databases. | `list(string)` | n/a | yes |
| description | The description of the AWS IAM policy.  Defaults to "The policy for [NAME]." | `string` | `""` | no |
| name | The name of the AWS IAM policy. | `string` | n/a | yes |
| require\_mfa | If true, actions require multi-factor authentication. | `string` | n/a | yes |
| result\_buckets | The ARNs of the AWS S3 buckets the store the results of the Athena queries.  Use ["*"] to allow all buckets. | `list(string)` | n/a | yes |
| source\_buckets | The ARNs of the AWS S3 buckets that store the source data.  Use ["*"] to allow all buckets. | `list(string)` | n/a | yes |
| source\_keys | The ARNs of the AWS KMS keys that can be used to decrypt source data files.  Use ["*"] to allow all keys. | `list(string)` | `[]` | no |
| workgroups | The ARNs of the AWS Athena workgroups that can be used.  Use ["*"] to allow all workgroups. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) of the AWS IAM policy. |
| id | The id of the AWS IAM policy. |
| name | The name of the AWS IAM policy. |
