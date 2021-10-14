/**
 * ## Usage
 *
 * Creates an IAM policy that allows use of AWS Athena.
 *
 * ```hcl
 * module "athena_iam_policy" {
 *   source = "dod-iac/athena-iam-policy/aws"
 *
 *   databases = [aws_glue_catalog_database.main.arn]
 *   name = format("%s-athena-user-%s", var.application, var.environment)
 *   result_buckets = [aws_s3_bucket.results.arn]
 *   require_mfa = true
 *   source_buckets = [aws_s3_bucket.source.arn]
 *   source_keys = ["*"]
 *   workgroups = [aws_athena_workgroup.main.arn]
 * }
 * ```
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_caller_identity" "current" {}

data "aws_iam_account_alias" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "main" {

  #
  # Data Catalogs
  #

  statement {
    actions = [
      "athena:ListDataCatalogs",
    ]
    effect    = "Allow"
    resources = ["*"]
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  #
  # Workgroups
  #

  statement {
    actions = [
      "athena:ListWorkGroups",
    ]
    effect    = "Allow"
    resources = ["*"]

    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  statement {
    actions = [
      "athena:GetWorkGroup",
    ]
    effect    = "Allow"
    resources = var.workgroups
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  #
  # Databases
  #

  statement {
    sid = "AllowGetDatabases"
    actions = [
      "glue:GetDatabases",
      "glue:GetDatabase"
    ]
    effect = "Allow"
    resources = sort(flatten([
      [
        format("arn:%s:glue:%s:%s:catalog",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id
        ),
      ],
      (length(var.databases) > 0 ? var.databases : [
        format("arn:%s:glue:%s:%s:database/*",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id
        )
      ])
    ]))
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  #
  # Tables
  #

  statement {
    sid = "AllowGetTables"
    actions = [
      "glue:GetTable",
      "glue:GetTables",
    ]
    effect = "Allow"
    resources = sort(flatten([
      [
        format("arn:%s:glue:%s:%s:catalog",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id
        ),
      ],
      (length(var.databases) > 0 ? var.databases : [
        format("arn:%s:glue:%s:%s:database/*",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id
        )
      ]),
      [
        format("arn:%s:glue:%s:%s:table/*",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id
        )
      ],
    ]))
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  #
  # Partitions
  #

  statement {
    sid = "AllowGetPartitions"
    actions = [
      "glue:GetPartitions",
      "glue:GetPartition",
    ]
    effect = "Allow"
    resources = sort(flatten([
      [
        format("arn:%s:glue:%s:%s:catalog",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id
        ),
      ],
      (length(var.databases) > 0 ? var.databases : [
        format("arn:%s:glue:%s:%s:database/*",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id
        )
      ]),
      [
        format("arn:%s:glue:%s:%s:table/*",
          data.aws_partition.current.partition,
          data.aws_region.current.name,
          data.aws_caller_identity.current.account_id
        )
      ],
    ]))
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  #
  # Queries
  #

  statement {
    actions = [
      # Submit Query and Retrieve Results
      "athena:GetQueryExecution",
      "athena:GetQueryResults",
      "athena:GetQueryResultsStream",
      "athena:StartQueryExecution",
      "athena:StopQueryExecution",
      # List previous queries for the workgroup
      "athena:ListQueryExecutions",
      "athena:BatchGetQueryExecution", # used by History tab
      # List saved queries
      "athena:ListNamedQueries",
      "athena:BatchGetNamedQuery", # used by Saved queries tab
      "athena:GetNamedQuery",      # used by Saved queries tab
      # Create a named query
      "athena:CreateNamedQuery"
    ]
    effect    = "Allow"
    resources = var.workgroups
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  dynamic "statement" {
    for_each = var.allow_delete_named_query ? [1] : []
    content {
      actions = [
        "athena:DeleteNamedQuery"
      ]
      effect    = "Allow"
      resources = var.workgroups
      dynamic "condition" {
        for_each = var.require_mfa ? [var.require_mfa] : []
        content {
          test     = "Bool"
          variable = "aws:MultiFactorAuthPresent"
          values   = ["true"]
        }
      }
    }
  }

  #
  # Sources
  #

  statement {
    sid = "ListBucket"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketRequestPayment",
      "s3:GetEncryptionConfiguration",
      "s3:ListBucket",
    ]
    effect    = length(var.source_buckets) > 0 ? "Allow" : "Deny"
    resources = length(var.source_buckets) > 0 ? var.source_buckets : ["*"]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"
      values   = ["athena.amazonaws.com"]
    }
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  statement {
    sid = "GetObject"
    actions = [
      "s3:GetObject",
    ]
    effect    = length(var.source_buckets) > 0 ? "Allow" : "Deny"
    resources = length(var.source_buckets) > 0 ? formatlist("%s/*", var.source_buckets) : ["*"]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"
      values   = ["athena.amazonaws.com"]
    }
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  #
  # Results
  #

  statement {
    sid = "CheckResults"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketRequestPayment",
      "s3:GetEncryptionConfiguration"
    ]
    effect    = length(var.result_buckets) > 0 ? "Allow" : "Deny"
    resources = length(var.result_buckets) > 0 ? var.result_buckets : ["*"]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"
      values   = ["athena.amazonaws.com"]
    }
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  statement {
    sid = "SaveResults"
    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload"
    ]
    effect    = length(var.result_buckets) > 0 ? "Allow" : "Deny"
    resources = length(var.result_buckets) > 0 ? formatlist("%s/*", var.result_buckets) : ["*"]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"
      values   = ["athena.amazonaws.com"]
    }
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  statement {
    sid = "GetResults"
    actions = [
      "s3:GetObject",
    ]
    effect    = length(var.result_buckets) > 0 ? "Allow" : "Deny"
    resources = length(var.result_buckets) > 0 ? formatlist("%s/*", var.result_buckets) : ["*"]
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

  #
  # Keys
  #

  statement {
    sid = "DecryptSourceDataFiles"
    actions = [
      "kms:ListAliases",
      "kms:Decrypt",
    ]
    effect    = length(var.source_keys) > 0 ? "Allow" : "Deny"
    resources = length(var.source_keys) > 0 ? var.source_keys : ["*"]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"
      values   = ["athena.amazonaws.com"]
    }
    dynamic "condition" {
      for_each = var.require_mfa ? [var.require_mfa] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }

}

resource "aws_iam_policy" "main" {
  name        = var.name
  description = length(var.description) > 0 ? var.description : format("The policy for %s.", var.name)
  policy      = data.aws_iam_policy_document.main.json
}
