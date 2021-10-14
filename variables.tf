variable "allow_delete_named_query" {
  type        = bool
  description = "If true, allows the deletion of named queries."
  default     = false
}

variable "source_buckets" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets that store the source data.  Use [\"*\"] to allow all buckets."
}

variable "result_buckets" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets the store the results of the Athena queries.  Use [\"*\"] to allow all buckets."
}

variable "description" {
  type        = string
  description = "The description of the AWS IAM policy.  Defaults to \"The policy for [NAME].\""
  default     = ""
}

variable "source_keys" {
  type        = list(string)
  description = "The ARNs of the AWS KMS keys that can be used to decrypt source data files.  Use [\"*\"] to allow all keys."
  default     = []
}

variable "name" {
  type        = string
  description = "The name of the AWS IAM policy."
}

variable "require_mfa" {
  type        = string
  description = "If true, actions require multi-factor authentication."
}

variable "databases" {
  type        = list(string)
  description = "The ARNs of the databases that can be used.  Use [\"*\"] to allow all databases."
}

variable "workgroups" {
  type        = list(string)
  description = "The ARNs of the AWS Athena workgroups that can be used.  Use [\"*\"] to allow all workgroups."
}
