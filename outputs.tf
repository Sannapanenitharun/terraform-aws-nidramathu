output "result_entry" {
  description = "Response from Cloudchipr API Callback function"
  value       = jsondecode(aws_lambda_invocation.lambda_execution_role_invoke.result)
}
