# AWS Account Connection Module for Nidramathu

## About

This module is designed to connect your AWS Organization/Account to Nidramathu. It creates IAM Roles with the necessary permissions and a Lambda function for setting up Nidramathu and starting to save.

## Usage Example

### Read and Write Access
```hcl
module "cloudchipr" {
    source  = "cloudchipr/connect-c8r/cloudchipr"
    version = "1.0.0"

    access_level = "read_write"
    data         = "00885,ea06c9aed56468d36,2d5a9e3e-d94a-488c-b903-b2826d,67037b4-8b9d095e55c2_d78KpAIS8tOwg6JCjV5WAfun,CloudchiprAccessRole-ea73a27660227fccee5d5cd5e7,CloudchiprCrossAccountRole-p5xNQ9PIA,CloudchiprBasicLambdaExecutionRole-p5xN3lA,CloudchiprAppCallback-p5xN3lwlfaVNB4XQ9PIA,cost-and-usage-report-p5xQ9PIA.csv,cloudchipr-p5xn3lwlfavnb4xq9pia,Create,2d5a9e3e-d94a-488c-b903-b2880cb8726d"
}
```

### Read Only Access
```hcl
module "cloudchipr" {
    source  = "cloudchipr/connect-c8r/cloudchipr"
    version = "1.0.0"

    access_level = "read"
    data         = "00885,ea06c9aed56468d36,2d5a9e3e-d94a-488c-b903-b2826d,67037b4-8b9d095e55c2_d78KpAIS8tOwg6JCjV5WAfun,CloudchiprAccessRole-ea73a27660227fccee5d5cd5e7,CloudchiprCrossAccountRole-p5xNQ9PIA,CloudchiprBasicLambdaExecutionRole-p5xN3lA,CloudchiprAppCallback-p5xN3lwlfaVNB4XQ9PIA,cost-and-usage-report-p5xQ9PIA.csv,cloudchipr-p5xn3lwlfavnb4xq9pia,Create,2d5a9e3e-d94a-488c-b903-b2880cb8726d"
}
```

#### The data field information is available at app.cloudchipr.com. Sign in to your Cloudchipr account and from account connection flow select `RUN THROUGH TERRAFORM`.

## License
Cloudchipr License. See [LICENSE](./LICENSE) for more information.

## Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.1 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.4.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.60.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.96.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.basic_lambda_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.cloudchipr_stack_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.cloudchipr_app_callback_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_invocation.lambda_execution_role_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.CloudchiprStack_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.CloudchiprStack_read-write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.SelfInspect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cost_optimization_hub_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_C8R_API_ENDPOINT"></a> [C8R\_API\_ENDPOINT](#input\_C8R\_API\_ENDPOINT) | API Endpoint used to verify account setup process. | `string` | `"https://api-bff.cloudchipr.com/providers/aws/account-attempts/"` | no |
| <a name="input_access_level"></a> [access\_level](#input\_access\_level) | Access level user wants to provide to Cloudchipr. | `string` | `"read_write"` | no |
| <a name="input_data"></a> [data](#input\_data) | Takes as input the source Account ID and Unique Key as External ID for cross-account trust relationship | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_result_entry"></a> [result\_entry](#output\_result\_entry) | Response from Cloudchipr API Callback function |
<!-- END_TF_DOCS -->
<!-- END_TF_DOCS -->
