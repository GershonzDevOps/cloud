# Terraform AWS VPC Project (Public + Private Subnets)

This project provisions a VPC in **us-east-1** with a typical two-tier network layout for learning and portfolio purposes.

## Architecture
- VPC (CIDR: `10.0.0.0/16`)
- 2 Public Subnets (multi-AZ)
- 2 Private Subnets (multi-AZ)
- Internet Gateway
- Public Route Table (routes public subnets to IGW)
- Private Route Table (no NAT by default to save cost)

> ✅ Note: NAT Gateway is intentionally disabled/removed to avoid charges.

## Prerequisites
- Terraform
- AWS CLI
- An AWS profile configured (example: `terraform`)

## How to Run
```bash
terraform init
terraform validate
terraform plan
terraform apply
