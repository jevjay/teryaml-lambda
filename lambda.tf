# Configure Lambda function
resource "aws_lambda_function" "lambda" {
  for_each = { for i in local.lambda : i.function_name => i }

  function_name    = each.value.function_name
  filename         = each.value.source
  handler          = each.value.handler
  source_code_hash = filebase64(each.value.source)
  role             = aws_iam_role.lambda[each.value.function_name].arn
  runtime          = each.value.runtime
  memory_size      = each.value.memory
  timeout          = each.value.timeout

  environment {
    variables = each.value.variables
  }

  dynamic "vpc_config" {
    for_each = each.value.vpc
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }

  }

  tags = local.tags
}
