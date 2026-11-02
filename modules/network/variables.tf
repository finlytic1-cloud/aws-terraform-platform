variable "name" {
  description = "Name prefix applied to all network resources."
  type        = string
}

variable "region" {
  description = "AWS region (used to build the S3 gateway endpoint service name)."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC. Must be a /16 so /24 subnets can be carved out of it."
  type        = string
  default     = "10.20.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0)) && endswith(var.vpc_cidr, "/16")
    error_message = "vpc_cidr must be a valid /16 CIDR block."
  }
}

variable "az_count" {
  description = "Number of availability zones to spread subnets across (2 or 3)."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count must be 2 or 3."
  }
}

variable "enable_nat_gateway" {
  description = "Create a single NAT gateway for private subnets. Costs money, so off by default."
  type        = bool
  default     = false
}
