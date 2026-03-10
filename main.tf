locals {
  request_type              = split(",", var.data)[10]
  response_url              = var.C8R_API_ENDPOINT
  service_token             = aws_lambda_function.cloudchipr_app_callback_lambda_function.arn
  role_arn                  = aws_iam_role.cloudchipr_stack_iam_role.arn
  account_id                = data.aws_caller_identity.current.account_id
  c8r_unique_id             = split(",", var.data)[2]
  confirmation_token        = split(",", var.data)[3]
  report_name               = split(",", var.data)[8]
  bucket_name               = split(",", var.data)[9]
  execution_type            = split(",", var.data)[10]
  iam_role                  = join("", ["arn:aws:iam::${local.account_id}:role/", split(",", var.data)[5]])
  unique_request_id         = split(",", var.data)[11]
  data_export_cur2_name     = split(",", var.data)[12]
  data_export_focus_name    = split(",", var.data)[13]
  data_export_opthub_report = split(",", var.data)[14]
  sub_account_role          = split(",", var.data)[15]
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [join("", ["arn:aws:iam::", split(",", var.data)[0], ":role/", split(",", var.data)[4]])]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [split(",", var.data)[1]]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "CloudchiprStack_read" {
  statement {
    actions = [
      "iam:DeleteRolePolicy",
      "iam:DeleteRole"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${split(",", var.data)[5]}"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "iam:DeleteRolePolicy",
      "iam:DeleteRole"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${split(",", var.data)[6]}"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "lambda:DeleteFunction",
      "lambda:InvokeFunction"
    ]
    resources = [
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${split(",", var.data)[7]}"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "account:Get*",
      "account:List*",
      "aoss:BatchGet*",
      "aoss:Get*",
      "aoss:List*",
      "application-autoscaling:Describe*",
      "application-cost-profiler:Get*",
      "application-cost-profiler:List*",
      "applicationinsights:Describe*",
      "applicationinsights:List*",
      "arc-zonal-shift:Get*",
      "arc-zonal-shift:List*",
      "athena:BatchGet*",
      "athena:Get*",
      "athena:List*",
      "autoscaling-plans:Describe*",
      "autoscaling-plans:Get*",
      "autoscaling:Describe*",
      "autoscaling:Get*",
      "aws-portal:Get*",
      "aws-portal:View*",
      "billing:Get*",
      "billing:List*",
      "billingconductor:List*",
      "budgets:Describe*",
      "budgets:View*",
      "ce:Describe*",
      "ce:Get*",
      "ce:List*",
      "cloudformation:BatchDescribe*",
      "cloudformation:Describe*",
      "cloudformation:Detect*",
      "cloudformation:EstimateTemplateCost",
      "cloudformation:Get*",
      "cloudformation:List*",
      "cloudformation:ValidateTemplate",
      "cloudfront:Describe*",
      "cloudfront:Get*",
      "cloudfront:List*",
      "cloudsearch:Describe*",
      "cloudsearch:List*",
      "cloudtrail:Describe*",
      "cloudtrail:Get*",
      "cloudtrail:List*",
      "cloudtrail:Lookup*",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "compute-optimizer:Describe*",
      "compute-optimizer:Get*",
      "consolidatedbilling:Get*",
      "consolidatedbilling:List*",
      "cur:Describe*",
      "cur:Get*",
      "cur:ValidateReportDestination",
      "bcm-data-exports:List*",
      "bcm-data-exports:Get*",
      "ce:StartCostAllocationTagBackfill",
      "ce:UpdateCostAllocationTagsStatus",
      "dax:BatchGet*",
      "dax:ConditionCheckItem",
      "dax:Describe*",
      "dax:Get*",
      "dax:List*",
      "docdb-elastic:Get*",
      "docdb-elastic:List*",
      "drs:Describe*",
      "drs:Get*",
      "drs:List*",
      "dynamodb:BatchGet*",
      "dynamodb:ConditionCheck*",
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:List*",
      "ebs:Get*",
      "ebs:List*",
      "ec2:Describe*",
      "ec2:Get*",
      "ec2:List*",
      "ec2:Search*",
      "ec2messages:Get*",
      "ecr-public:BatchCheckLayerAvailability",
      "ecr-public:Describe*",
      "ecr-public:Get*",
      "ecr-public:List*",
      "ecs:Describe*",
      "ecs:Get*",
      "ecs:List*",
      "eks:AccessKubernetesApi",
      "eks:Describe*",
      "eks:List*",
      "elastic-inference:Describe*",
      "elastic-inference:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticloadbalancing:Describe*",
      "es:Describe*",
      "es:ESCrossClusterGet",
      "es:ESHttpGet",
      "es:ESHttpHead",
      "es:Get*",
      "es:List*",
      "events:Describe*",
      "events:List*",
      "events:TestEventPattern",
      "evidently:Get*",
      "evidently:List*",
      "evidently:TestSegmentPattern",
      "forecast:Describe*",
      "forecast:Get*",
      "forecast:InvokeForecastEndpoint",
      "forecast:List*",
      "freetier:Get*",
      "glacier:Describe*",
      "glacier:Get*",
      "glacier:List*",
      "glue:BatchGet*",
      "glue:CheckSchemaVersionValidity",
      "glue:Get*",
      "glue:List*",
      "grafana:Describe*",
      "grafana:List*",
      "iam:ListAccountAliases",
      "imagebuilder:Get*",
      "imagebuilder:List*",
      "kafka-cluster:Describe*",
      "kafka:Describe*",
      "kafka:Get*",
      "kafka:List*",
      "kafkaconnect:Describe*",
      "kafkaconnect:List*",
      "kinesis:Describe*",
      "kinesis:Get*",
      "kinesis:List*",
      "kinesisanalytics:Describe*",
      "kinesisanalytics:DiscoverInputSchema",
      "kinesisanalytics:Get*",
      "kinesisanalytics:List*",
      "kinesisvideo:Describe*",
      "kinesisvideo:Get*",
      "kinesisvideo:List*",
      "kms:Describe*",
      "kms:List*",
      "lakeformation:Describe*",
      "lakeformation:Get*",
      "lakeformation:List*",
      "lambda:Get*",
      "lambda:List*",
      "logs:Describe*",
      "logs:FilterLogEvents",
      "logs:Get*",
      "logs:List*",
      "logs:TestMetricFilter",
      "logs:Unmask",
      "machinelearning:Describe*",
      "machinelearning:Get*",
      "memorydb:Describe*",
      "memorydb:List*",
      "notifications:Get*",
      "notifications:List*",
      "organizations:Describe*",
      "organizations:List*",
      "osis:Get*",
      "osis:List*",
      "osis:ValidatePipeline",
      "pipes:Describe*",
      "pipes:List*",
      "pricing:Describe*",
      "pricing:Get*",
      "pricing:List*",
      "qldb:Describe*",
      "qldb:Get*",
      "qldb:List*",
      "quicksight:Describe*",
      "quicksight:Get*",
      "quicksight:List*",
      "rds:Describe*",
      "rds:List*",
      "redshift-data:Describe*",
      "redshift-data:Get*",
      "redshift-data:List*",
      "redshift-serverless:Get*",
      "redshift-serverless:List*",
      "resource-explorer-2:BatchGet*",
      "resource-explorer-2:Get*",
      "resource-explorer-2:List*",
      "resource-explorer:List*",
      "resource-groups:Get*",
      "resource-groups:List*",
      "route53-recovery-cluster:Get*",
      "route53-recovery-cluster:List*",
      "route53-recovery-control-config:Describe*",
      "route53-recovery-control-config:List*",
      "route53-recovery-readiness:Get*",
      "route53-recovery-readiness:List*",
      "route53:Get*",
      "route53:List*",
      "route53:TestDNSAnswer",
      "route53domains:CheckDomainAvailability",
      "route53domains:CheckDomainTransferability",
      "route53domains:Get*",
      "route53domains:List*",
      "route53domains:View*",
      "route53resolver:Get*",
      "route53resolver:List*",
      "rum:BatchGet*",
      "rum:Get*",
      "rum:List*",
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*",
      "s3-outposts:Get*",
      "s3-outposts:List*",
      "s3:Describe*",
      "s3:Get*",
      "s3:List*",
      "sagemaker-geospatial:Get*",
      "sagemaker-geospatial:List*",
      "sagemaker-groundtruth-synthetic:Get*",
      "sagemaker-groundtruth-synthetic:List*",
      "sagemaker:BatchDescribe*",
      "sagemaker:BatchGet*",
      "sagemaker:Describe*",
      "sagemaker:Get*",
      "sagemaker:InvokeEndpoint",
      "sagemaker:InvokeEndpointAsync",
      "sagemaker:List*",
      "sagemaker:RenderUiTemplate",
      "savingsplans:Describe*",
      "savingsplans:List*",
      "scheduler:Get*",
      "scheduler:List*",
      "schemas:Describe*",
      "schemas:Get*",
      "schemas:List*",
      "sdb:DomainMetadata",
      "sdb:Get*",
      "sdb:List*",
      "servicecatalog:Describe*",
      "servicecatalog:Get*",
      "servicecatalog:List*",
      "servicequotas:Get*",
      "servicequotas:List*",
      "ses:BatchGetMetricData",
      "ses:Describe*",
      "ses:Get*",
      "ses:List*",
      "snowball:Describe*",
      "snowball:Get*",
      "snowball:List*",
      "sns:Get*",
      "sns:List*",
      "sqlworkbench:BatchGet*",
      "sqlworkbench:Get*",
      "sqlworkbench:List*",
      "sqs:Get*",
      "sqs:List*",
      "storagegateway:Describe*",
      "storagegateway:List*",
      "synthetics:Describe*",
      "synthetics:Get*",
      "synthetics:List*",
      "tag:Describe*",
      "tag:Get*",
      "timestream:Describe*",
      "timestream:Get*",
      "timestream:List*",
      "transfer:Describe*",
      "transfer:List*",
      "transfer:TestIdentityProvider",
      "trustedadvisor:Describe*",
      "trustedadvisor:Get*",
      "trustedadvisor:List*",
      "wellarchitected:Get*",
      "wellarchitected:List*",
      "backup:List*"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/${tostring(split(",", var.data)[15])}", "arn:aws:iam::*:role/CloudchiprAccountReadAccessRole", "arn:aws:iam::*:role/CloudchiprAccountReadWriteAccessRole"]
    effect    = "Allow"
  }

}

data "aws_iam_policy_document" "CloudchiprStack_read-write" {
  statement {
    actions = [
      "iam:DeleteRolePolicy",
      "iam:DeleteRole"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${split(",", var.data)[6]}"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "iam:DeleteRolePolicy",
      "iam:DeleteRole"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${split(",", var.data)[5]}"
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "lambda:DeleteFunction",
      "lambda:InvokeFunction"
    ]
    resources = [
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${split(",", var.data)[7]}"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "account:*",
      "aoss:*",
      "application-autoscaling:Describe*",
      "application-cost-profiler:Get*",
      "application-cost-profiler:List*",
      "applicationinsights:Describe*",
      "applicationinsights:List*",
      "arc-zonal-shift:Get*",
      "arc-zonal-shift:List*",
      "athena:BatchGet*",
      "athena:Get*",
      "athena:List*",
      "athena:Delete*",
      "athena:Update*",
      "athena:Cancel*",
      "autoscaling-plans:*",
      "autoscaling:*",
      "aws-portal:Get*",
      "aws-portal:View*",
      "billing:*",
      "billingconductor:List*",
      "budgets:*",
      "ce:*",
      "cloudformation:*",
      "cloudfront:Describe*",
      "cloudfront:Get*",
      "cloudfront:List*",
      "cloudsearch:Describe*",
      "cloudsearch:List*",
      "cloudsearch:Delete*",
      "cloudsearch:Update*",
      "cloudtrail:Describe*",
      "cloudtrail:Get*",
      "cloudtrail:List*",
      "cloudtrail:Lookup*",
      "cloudwatch:*",
      "compute-optimizer:Describe*",
      "compute-optimizer:Get*",
      "consolidatedbilling:Get*",
      "consolidatedbilling:List*",
      "cur:*",
      "bcm-data-exports:*",
      "ce:*",
      "dax:BatchGet*",
      "dax:ConditionCheckItem",
      "dax:Describe*",
      "dax:Get*",
      "dax:List*",
      "dax:Delete*",
      "dax:Update*",
      "docdb-elastic:*",
      "drs:Describe*",
      "drs:Get*",
      "drs:List*",
      "dynamodb:BatchGet*",
      "dynamodb:ConditionCheck*",
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:List*",
      "dynamodb:Delete*",
      "dynamodb:Disable*",
      "dynamodb:Update*",
      "ebs:*",
      "ec2:*",
      "ec2messages:*",
      "ecr-public:*",
      "ecs:*",
      "eks:*",
      "elastic-inference:Describe*",
      "elastic-inference:List*",
      "elasticache:Delete*",
      "elasticache:Decrease*",
      "elasticache:Increase*",
      "elasticache:Disassociate*",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:Describe*",
      "es:*",
      "events:Describe*",
      "events:List*",
      "events:TestEventPattern",
      "evidently:Get*",
      "evidently:List*",
      "evidently:TestSegmentPattern",
      "forecast:Describe*",
      "forecast:Get*",
      "forecast:InvokeForecastEndpoint",
      "forecast:List*",
      "freetier:Get*",
      "glacier:*",
      "glue:*",
      "grafana:Describe*",
      "grafana:List*",
      "iam:ListAccountAliases",
      "imagebuilder:*",
      "kafka-cluster:*",
      "kafka:*",
      "kafkaconnect:Describe*",
      "kafkaconnect:List*",
      "kinesis:*",
      "kinesisanalytics:*",
      "kinesisvideo:*",
      "kms:Describe*",
      "kms:List*",
      "kms:Delete*",
      "kms:Disable*",
      "kms:Update*",
      "lakeformation:Describe*",
      "lakeformation:Get*",
      "lakeformation:List*",
      "lambda:Get*",
      "lambda:List*",
      "logs:Describe*",
      "logs:FilterLogEvents",
      "logs:Get*",
      "logs:List*",
      "logs:TestMetricFilter",
      "logs:Unmask",
      "machinelearning:*",
      "memorydb:*",
      "notifications:Get*",
      "notifications:List*",
      "organizations:Describe*",
      "organizations:List*",
      "osis:*",
      "pipes:Describe*",
      "pipes:List*",
      "pricing:Describe*",
      "pricing:Get*",
      "pricing:List*",
      "qldb:Describe*",
      "qldb:Get*",
      "qldb:List*",
      "quicksight:Describe*",
      "quicksight:Get*",
      "quicksight:List*",
      "rds:*",
      "redshift-data:Describe*",
      "redshift-data:Get*",
      "redshift-data:List*",
      "redshift-serverless:*",
      "resource-explorer-2:BatchGet*",
      "resource-explorer-2:Get*",
      "resource-explorer-2:List*",
      "resource-explorer:List*",
      "resource-groups:Get*",
      "resource-groups:List*",
      "route53-recovery-cluster:Get*",
      "route53-recovery-cluster:List*",
      "route53-recovery-control-config:Describe*",
      "route53-recovery-control-config:List*",
      "route53-recovery-readiness:Get*",
      "route53-recovery-readiness:List*",
      "route53:Get*",
      "route53:List*",
      "route53:TestDNSAnswer",
      "route53domains:CheckDomainAvailability",
      "route53domains:CheckDomainTransferability",
      "route53domains:Get*",
      "route53domains:List*",
      "route53domains:View*",
      "route53resolver:Get*",
      "route53resolver:List*",
      "rum:BatchGet*",
      "rum:Get*",
      "rum:List*",
      "s3-object-lambda:*",
      "s3-outposts:*",
      "s3:*",
      "sagemaker-geospatial:*",
      "sagemaker-groundtruth-synthetic:*",
      "sagemaker:*",
      "savingsplans:*",
      "scheduler:Get*",
      "scheduler:List*",
      "schemas:Describe*",
      "schemas:Get*",
      "schemas:List*",
      "sdb:DomainMetadata",
      "sdb:Delete*",
      "sdb:Get*",
      "sdb:List*",
      "servicecatalog:*",
      "ses:BatchGetMetricData",
      "ses:Describe*",
      "ses:Get*",
      "ses:List*",
      "snowball:*",
      "sns:*",
      "sqlworkbench:BatchGet*",
      "sqlworkbench:Get*",
      "sqlworkbench:List*",
      "sqs:*",
      "storagegateway:Describe*",
      "storagegateway:List*",
      "synthetics:Describe*",
      "synthetics:Get*",
      "synthetics:List*",
      "tag:*",
      "timestream:Describe*",
      "timestream:Get*",
      "timestream:List*",
      "transfer:Describe*",
      "transfer:List*",
      "transfer:TestIdentityProvider",
      "trustedadvisor:Describe*",
      "trustedadvisor:Get*",
      "trustedadvisor:List*",
      "wellarchitected:Get*",
      "wellarchitected:List*",
      "backup:List*",
      "backup:DeleteRecoveryPoint"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/${tostring(split(",", var.data)[15])}", "arn:aws:iam::*:role/CloudchiprAccountReadAccessRole", "arn:aws:iam::*:role/CloudchiprAccountReadWriteAccessRole"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "SelfInspect" {
  statement {
    sid = "AllowRoleToInspectItself"
    actions = [
      "iam:ListRolePolicies",
      "iam:GetRolePolicy"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${split(",", var.data)[5]}"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_role" "cloudchipr_stack_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = "/"
  name               = split(",", var.data)[5]

  inline_policy {
    name   = "CloudchiprStack"
    policy = var.access_level == "read" ? data.aws_iam_policy_document.CloudchiprStack_read.json : data.aws_iam_policy_document.CloudchiprStack_read-write.json
  }

  inline_policy {
    name   = "SelfInspect"
    policy = data.aws_iam_policy_document.SelfInspect.json
  }
}

data "aws_iam_policy_document" "assume_role_execution" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "execution_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "organizations:DescribeOrganization",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "organizations:DescribeAccount"
    ]

    resources = ["*"]
  }
  statement {
    effect = "Allow"

    actions = [
      "iam:ListAccountAliases",
      "iam:CreateServiceLinkedRole",
      "iam:GetRole"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:CreateBucket",
      "s3:PutBucketPolicy",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${split(",", var.data)[9]}"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "cur:DescribeReportDefinitions",
      "cur:PutReportDefinition",
      "bcm-data-exports:CreateExport",
      "bcm-data-exports:ListExports",
      "ce:StartCostAllocationTagBackfill",
      "ce:UpdateCostAllocationTagsStatus"
    ]

    resources = ["*"]
  }

}

data "aws_iam_policy_document" "cost_optimization_hub_policy" {
  statement {
    effect = "Allow"
    actions = [
      "cost-optimization-hub:GetRecommendation",
      "cost-optimization-hub:ListRecommendations",
      "cost-optimization-hub:GetPreferences",
      "cost-optimization-hub:UpdatePreferences",
      "cost-optimization-hub:UpdateEnrollmentStatus",
      "cost-optimization-hub:ListEnrollmentStatuses",
      "organizations:EnableAWSServiceAccess"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "basic_lambda_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_execution.json
  path               = "/"
  name               = split(",", var.data)[6]

  inline_policy {
    name   = "BasicLambdaExecutionPolicy"
    policy = data.aws_iam_policy_document.execution_role_policy.json
  }
  inline_policy {
    name   = "CostOptimizationHubRecommendationPolicy"
    policy = data.aws_iam_policy_document.cost_optimization_hub_policy.json
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.js"
  output_path = "${path.module}/lambda/lambda_function.zip"
}

resource "aws_lambda_function" "cloudchipr_app_callback_lambda_function" {
  depends_on = [aws_iam_role.basic_lambda_execution_role]

  function_name = split(",", var.data)[7]
  description   = "Report Cloudchipr Role ARN to Cloudchipr"
  filename      = data.archive_file.lambda.output_path
  handler       = "index.handler"
  role          = aws_iam_role.basic_lambda_execution_role.arn
  runtime       = "nodejs20.x"
  timeout       = 30
  environment {
    variables = {
      C8R_API_ENDPOINT = var.C8R_API_ENDPOINT
      IS_TERRAFORM     = true
    }
  }
}

resource "aws_lambda_invocation" "lambda_execution_role_invoke" {
  depends_on    = [aws_lambda_function.cloudchipr_app_callback_lambda_function]
  function_name = aws_lambda_function.cloudchipr_app_callback_lambda_function.function_name

  input = jsonencode({
    "RequestType" : local.request_type,
    "ResponseURL" : local.response_url,
    "ResourceProperties" : {
      "ServiceToken" : local.service_token,
      "RoleArn" : local.role_arn,
      "AccountId" : local.account_id,
      "C8RUniqueId" : local.c8r_unique_id,
      "ConfirmationToken" : local.confirmation_token,
      "ReportName" : local.report_name,
      "BucketName" : local.bucket_name,
      "ExecutionType" : local.execution_type,
      "IAMRole" : local.iam_role,
      "UniqueRequestId" : local.unique_request_id
      "DataExportCUR2Name" : local.data_export_cur2_name
      "DataExportFOCUSName" : local.data_export_focus_name
      "DataExportCostOptimizationRecommendationName" : local.data_export_opthub_report
      "SubAccountsAssumeRoleName" : local.sub_account_role
    }
  })
}
