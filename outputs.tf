# ═══════════════════════════════════════════════════════════════
#  outputs.tf — nidramathu FinOps Platform
# ═══════════════════════════════════════════════════════════════

output "finops_data_bucket" {
  description = "S3 bucket name for FinOps data & reports"
  value       = aws_s3_bucket.finops_data.bucket
}

output "finops_data_bucket_arn" {
  description = "ARN of the FinOps data S3 bucket"
  value       = aws_s3_bucket.finops_data.arn
}

output "lambda_artifacts_bucket" {
  description = "S3 bucket for Lambda deployment artifacts"
  value       = aws_s3_bucket.lambda_artifacts.bucket
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.nidramathu.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS database port"
  value       = aws_db_instance.nidramathu.port
}

output "lambda_function_name" {
  description = "Cost reporter Lambda function name"
  value       = aws_lambda_function.cost_reporter.function_name
}

output "lambda_function_arn" {
  description = "Cost reporter Lambda function ARN"
  value       = aws_lambda_function.cost_reporter.arn
}

output "sns_alerts_topic_arn" {
  description = "SNS topic ARN for FinOps alerts"
  value       = aws_sns_topic.finops_alerts.arn
}

output "cloudwatch_dashboard_url" {
  description = "URL to the CloudWatch FinOps dashboard"
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.nidramathu.dashboard_name}"
}

output "monthly_budget_name" {
  description = "AWS Budgets budget name"
  value       = aws_budgets_budget.monthly_cost.name
}
