---
title: Terraform
track: terraform
category: Skill-based
tags: [roadmap, terraform, devops]
---

# Terraform

> roadmap.sh: https://roadmap.sh/terraform

Suggested path through the **Terraform** nodes. Each node links to its lesson when written.

## Nodes

### Foundations
- What is Infrastructure as Code
- Why IaC and its benefits
- Declarative vs imperative IaC
- What is Terraform
- Terraform vs other IaC tools (CloudFormation, Pulumi, Ansible)
- OpenTofu vs Terraform
- Mutable vs immutable infrastructure

### Setup & basics
- Installing Terraform
- Terraform CLI overview
- HCL (HashiCorp Configuration Language)
- Providers
- terraform init
- terraform plan
- terraform apply
- terraform destroy
- Authentication to providers

### Core concepts
- Resources
- Data sources
- Arguments and attributes
- Resource dependencies (implicit and explicit)
- depends_on
- Resource addressing
- The resource graph
- Lifecycle meta-arguments

### Variables & outputs
- Input variables
- Variable types and validation
- Default values
- tfvars files
- Environment variables
- Local values
- Output values
- Sensitive values

### State
- What is Terraform state
- The state file
- Local vs remote state
- Remote backends (S3, GCS, Azure)
- State locking
- terraform state commands
- Importing existing resources
- Refresh and drift detection
- State migration

### Expressions & functions
- Built-in functions
- Conditional expressions
- for expressions
- Splat expressions
- Dynamic blocks
- count
- for_each
- Type constraints and conversion

### Modules
- What are modules
- Root vs child modules
- Module inputs and outputs
- Calling modules
- Module sources (local, Git, registry)
- Terraform Registry
- Module versioning
- Composing and structuring modules

### Provisioners & workflow
- Provisioners (local-exec, remote-exec)
- When not to use provisioners
- terraform fmt
- terraform validate
- terraform console
- Workspaces
- Targeting resources
- Tainting and replacing

### Collaboration & multi-environment
- Managing multiple environments
- Directory structure strategies
- Remote backends for teams
- Terraform Cloud / HCP Terraform
- Sentinel and policy as code
- CI/CD with Terraform
- Secrets management (Vault, SOPS)

### Best practices & advanced
- Code organization and DRY
- Naming conventions
- Pinning provider and module versions
- Testing (terraform test, Terratest)
- Linting (tflint) and security scanning (tfsec, Checkov)
- Drift management
- Writing a custom provider (overview)
- Cost estimation (Infracost)

## Resources
See [resources.md](./resources.md).

## Project ideas
- Provision a complete AWS VPC (subnets, route tables, security groups, an EC2 instance) entirely in Terraform with remote state in an S3 backend and DynamoDB locking.
- Refactor a flat configuration into reusable modules, publish one to a private registry, and consume it across dev/staging/prod with tfvars.
- Build a GitHub Actions pipeline that runs `fmt`, `validate`, `tflint`, a security scan, and `plan` on PRs, then `apply` on merge to main.
