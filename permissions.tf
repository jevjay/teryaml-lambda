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

# A Lambda function may access to other AWS resources such as S3 bucket. So an
# IAM role needs to be defined.
resource "aws_iam_role" "lambda" {
  for_each = { for i in local.lambda : i.function_name => i }

  name = lookup(each.value.permissions[0], "role", null)
  path = lookup(each.value.permissions[0], "path", null)

  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json

  tags = local.tags
}

# Optional IAM policy, which is used to extend lambda permissions
resource "aws_iam_role_policy" "permissions" {
  for_each = { for i in local.lambda : i.function_name => i if length(lookup(i.permissions[0], "policy", "")) > 0 }

  name   = each.value.function_name
  role   = aws_iam_role.lambda[each.value.function_name].id
  policy = lookup(each.value.permissions[0], "policy", "")
}
