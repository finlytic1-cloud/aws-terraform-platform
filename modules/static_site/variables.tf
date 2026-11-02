variable "name" {
  description = "Name prefix for the site resources (lowercase letters, numbers, hyphens)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,40}$", var.name))
    error_message = "name must be 3-40 characters: lowercase letters, numbers and hyphens only."
  }
}

variable "force_destroy" {
  description = "Allow Terraform to delete the bucket even if it contains objects (fine for dev, not for prod)."
  type        = bool
  default     = false
}
