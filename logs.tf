# Logs configuration for Lambda function
# This is to manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "lambda" {
  for_each = { for i in local.lambda : i.function_name => i }

  name              = lookup(each.value.logs[0], "group_name", null)
  retention_in_days = lookup(each.value.logs[0], "retention", null)

  tags = local.tags
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  for_each = { for i in local.lambda : i.function_name => i }

  name        = "${each.value.function_name}-logging"
  path        = lookup(each.value.permissions[0], "path", null)
  description = "IAM policy for logging from a lambda"

  policy = data.aws_iam_policy_document.lambda_logging.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  for_each = { for i in local.lambda : i.function_name => i }

  role       = aws_iam_role.lambda[each.value.function_name].name
  policy_arn = aws_iam_policy.lambda_logging[each.value.function_name].arn
}
