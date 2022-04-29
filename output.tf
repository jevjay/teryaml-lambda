output "lambda_arn" {
  description = "Amazon Resource Name (ARN)"
  value = [
    for i in aws_lambda_function.lambda : i.arn
  ]
}

output "lambda_invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway"
  value = [
    for i in aws_lambda_function.lambda : i.invoke_arn
  ]
}

output "lambda_id" {
  description = "Lambda function name"
  value = [
    for i in local.lambda : i.function_name
  ]
}
