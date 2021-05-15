data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid = "AllowLambdaWriteLogs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "AllowReadCICD"
    actions = [
      "codepipeline:Get*",
      "codepipeline:List*",
      "codebuild:Get*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "AllowKMSAccess"
    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*"
    ]
    resources = [
      "*"
    ]
  }
  # Allow reading CodeCommit repositories data,
  statement {
    sid = "AllowCodeCommitReadAccess"
    actions = [
      "codecommit:BatchGet*",
      "codecommit:BatchDescribe*",
      "codecommit:Describe*",
      "codecommit:EvaluatePullRequestApprovalRules",
      "codecommit:Get*",
      "codecommit:List*",
    ]
    resources = [
      "*"
    ]
  }
}

data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_file = var.lambda_source_file
  source_dir  = var.lambda_source_dir
  output_path = "${path.module}/${var.name}.zip"
  excludes    = var.lambda_source_excludes
}

# A Lambda function may access to other AWS resources such as S3 bucket. So an
# IAM role needs to be defined.
resource "aws_iam_role" "lambda" {
  name               = local.expanded_lambda_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role_policy" "lambda" {
  name   = "${local.expanded_lambda_name}-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda.json
}

# Optional IAM policy, which is used to extend lambda permissions
resource "aws_iam_role_policy" "custom_lambda" {
  for_each = var.lambda_additional_policies

  name   = each.key
  role   = aws_iam_role.lambda.id
  policy = each.value
}

# Configure Lambda function
resource "aws_lambda_function" "lambda" {
  function_name    = local.expanded_lambda_name
  filename         = data.archive_file.lambda_function_zip.output_path
  handler          = var.name
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
  role             = aws_iam_role.lambda.arn
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout

  dynamic "environment" {
    for_each = var.environment

    content {
      variables = environment.value.variables
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config

    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  tags = local.common_tags

  # ... forced dependencies ...
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda,
  ]
}
