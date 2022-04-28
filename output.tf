output "lambda_arn" {
  value = [
    for function in aws_lambda_function.lambda : function.arn
  ]
}
