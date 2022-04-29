output "lambda_arn" {
  description = "Amazon Resource Name (ARN)"
  value = [
    for function in aws_lambda_function.lambda : function.arn
  ]
}

output "lambda_invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway"
  value = [
    for function in aws_lambda_function.lambda : function.invoke_arn
  ]
}
