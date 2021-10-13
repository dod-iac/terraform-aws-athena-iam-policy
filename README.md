<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.55.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_account_alias.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_account_alias) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_delete_named_query"></a> [allow\_delete\_named\_query](#input\_allow\_delete\_named\_query) | If true, allows the deletion of named queries. | `bool` | `false` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | The ARNs of the databases that can be used.  Use ["*"] to allow all databases. | `list(string)` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The description of the AWS IAM policy.  Defaults to "The policy for [NAME]." | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the AWS IAM policy. | `string` | n/a | yes |
| <a name="input_require_mfa"></a> [require\_mfa](#input\_require\_mfa) | If true, actions require multi-factor authentication. | `string` | n/a | yes |
| <a name="input_result_buckets"></a> [result\_buckets](#input\_result\_buckets) | The ARNs of the AWS S3 buckets the store the results of the Athena queries.  Use ["*"] to allow all buckets. | `list(string)` | n/a | yes |
| <a name="input_source_buckets"></a> [source\_buckets](#input\_source\_buckets) | The ARNs of the AWS S3 buckets that store the source data.  Use ["*"] to allow all buckets. | `list(string)` | n/a | yes |
| <a name="input_source_keys"></a> [source\_keys](#input\_source\_keys) | The ARNs of the AWS KMS keys that can be used to decrypt source data files.  Use ["*"] to allow all keys. | `list(string)` | `[]` | no |
| <a name="input_workgroups"></a> [workgroups](#input\_workgroups) | The ARNs of the AWS Athena workgroups that can be used.  Use ["*"] to allow all workgroups. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the AWS IAM policy. |
| <a name="output_id"></a> [id](#output\_id) | The id of the AWS IAM policy. |
| <a name="output_name"></a> [name](#output\_name) | The name of the AWS IAM policy. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
