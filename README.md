# aws-terraform-platform

A small, modular AWS platform defined entirely in Terraform. It is built to show good infrastructure-as-code habits (modules, validated inputs, least-privilege IAM, remote state, CI) rather than to be large.

## What it builds

| Module | What it creates |
| --- | --- |
| `modules/network` | A VPC with public and private subnets across 2 AZs, an internet gateway, a locked-down default security group, a free S3 gateway endpoint, and an optional NAT gateway (off by default to keep costs near zero). |
| `modules/static_site` | A private, encrypted, versioned S3 bucket served through CloudFront using Origin Access Control (OAC). HTTPS only, public access blocked, insecure transport denied. |
| `modules/github_oidc` | A GitHub Actions OIDC identity provider and a deploy role. Only one repo and branch can assume it, and it can only sync one bucket and invalidate one distribution. No long-lived AWS keys anywhere. |
| `bootstrap/` | A one-off stack creating the S3 bucket for remote Terraform state (versioned, encrypted, with `prevent_destroy`). |

## Layout

```
.
├── bootstrap/               # remote-state bucket (run once, local state)
├── environments/
│   └── dev/                 # wires the modules together for a dev environment
├── modules/
│   ├── network/
│   ├── static_site/
│   └── github_oidc/
└── .github/workflows/
    └── terraform-ci.yml     # fmt, validate, tflint, checkov on every push and PR
```

## Design decisions

- **Modules with typed, validated inputs.** For example `vpc_cidr` must be a `/16`, and `github_repo` must look like `owner/repo`, so mistakes fail at plan time with a clear message.
- **Cost-aware defaults.** The NAT gateway is the one expensive part of a VPC, so it sits behind `enable_nat_gateway = false`. CloudFront uses `PriceClass_100`. With defaults the whole stack costs close to nothing.
- **Least privilege.** The GitHub deploy role is scoped to one repo, one branch, one bucket and one distribution.
- **No stored credentials.** CI authenticates to AWS with short-lived OIDC tokens, not access keys.
- **Provider and version pinning.** `required_version` and `~>` provider constraints, with `.terraform.lock.hcl` committed once you run `init`.
- **CI without credentials.** The workflow runs `terraform fmt -check`, `terraform init -backend=false`, `terraform validate`, `tflint` and `checkov`, so it works on a fork with no AWS account.

## Prerequisites

- Terraform 1.9+ (1.10+ if you use the S3 `use_lockfile` backend option)
- An AWS account and credentials configured locally (`aws configure` or SSO)

## Usage

```bash
# 1. (Optional) create the remote state bucket
cd bootstrap
terraform init
terraform apply

# 2. Deploy the dev environment
cd ../environments/dev
cp terraform.tfvars.example terraform.tfvars   # edit github_repo to your own owner/repo
terraform init
terraform plan
terraform apply

# Optional: move state to the bucket from step 1
mv backend.tf.example backend.tf   # replace the bucket name first
terraform init -migrate-state
```

After `apply`, the outputs include `site_url` (your CloudFront HTTPS URL) and `github_deploy_role_arn`.

Tear everything down when you are done:

```bash
terraform destroy
```

## Notes

- AWS allows **one** GitHub OIDC provider per account. If your account already has one, import it (`terraform import`) or remove it from the `github_oidc` module before applying.
- CloudFront can take a few minutes to deploy or delete.

## Possible next steps

- Add a `plan`-on-PR workflow that assumes the OIDC role.
- Add an ECS Fargate service module that runs a Docker image from ECR inside the private subnets.
- Add CloudWatch alarms and an SNS topic for the site.
- Add a `prod` environment that reuses the same modules.
