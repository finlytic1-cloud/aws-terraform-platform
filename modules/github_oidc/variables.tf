variable "name" {
  description = "Name prefix for the IAM role."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository allowed to assume the role, in the form owner/repo."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$", var.github_repo))
    error_message = "github_repo must look like owner/repo."
  }
}

variable "github_branch" {
  description = "Branch allowed to deploy."
  type        = string
  default     = "main"
}

variable "site_bucket_arn" {
  description = "ARN of the S3 bucket the role may write to."
  type        = string
}

variable "distribution_arn" {
  description = "ARN of the CloudFront distribution the role may invalidate."
  type        = string
}
