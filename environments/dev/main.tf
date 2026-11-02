terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81"
    }
  }
}

provider "aws" {
  region = var.region

  # Every resource gets these tags automatically (handy for cost tracking and clean-up).
  default_tags {
    tags = {
      Project     = var.project
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}

module "network" {
  source = "../../modules/network"

  name               = "${var.project}-dev"
  region             = var.region
  vpc_cidr           = var.vpc_cidr
  az_count           = 2
  enable_nat_gateway = var.enable_nat_gateway
}

module "static_site" {
  source = "../../modules/static_site"

  name          = "${var.project}-dev"
  force_destroy = true # dev only: lets `terraform destroy` empty and remove the bucket
}

module "github_oidc" {
  source = "../../modules/github_oidc"

  name             = "${var.project}-dev"
  github_repo      = var.github_repo
  github_branch    = "main"
  site_bucket_arn  = module.static_site.bucket_arn
  distribution_arn = module.static_site.distribution_arn
}
