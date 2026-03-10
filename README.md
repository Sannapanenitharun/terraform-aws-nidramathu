# Terraform AWS Nidramathu Module

This module creates an IAM Role for connecting AWS accounts to the Nidramathu platform.

## Usage

module "nidramathu" {
  source = "sannapanenitharun/nidramathu/aws"

  platform_account = "123456789012"
  external_id      = "external-id"
}

## Inputs

| Name | Description | Type |
|-----|-------------|------|
| platform_account | Platform AWS account ID | string |
| external_id | External ID for AssumeRole | string |

## Outputs

| Name | Description |
|-----|-------------|
| role_arn | IAM role ARN |
