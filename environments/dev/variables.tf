variable "project" {
  description = "Short project name used as a prefix and tag."
  type        = string
  default     = "platform-demo"
}

variable "region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-west-2" # London
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (/16)."
  type        = string
  default     = "10.20.0.0/16"
}

variable "enable_nat_gateway" {
  description = "Create a NAT gateway (about $1/day plus data). Leave false to stay near-free."
  type        = bool
  default     = false
}

variable "github_repo" {
  description = "GitHub repo (owner/repo) allowed to deploy via OIDC. Change this to your own."
  type        = string
  default     = "finlytic1-cloud/aws-terraform-platform"
}
