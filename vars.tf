variable "name" {
  type        = string
  description = "Lambda function name"
}

variable "runtime" {
  type        = string
  description = "Lambda runtime type and version"
}

variable "lambda_source_file" {
  type        = string
  description = "Lambda function package/binary path, which will be archived and uploaded as the Lambda source"

  default = ""
}

variable "lambda_source_dir" {
  type        = string
  description = "Lambda function package directory path, which will be archived and uploaded as the Lambda source"

  default = ""
}

variable "lambda_source_excludes" {
  type        = list(any)
  description = "Specify files to ignore when reading the Lambda source directory. Requires `lambda_source_dir` variable"

  default = []
}

variable "memory_size" {
  type        = number
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128"

  default = 128
}

variable "timeout" {
  type        = number
  description = " Amount of time your Lambda Function has to run in seconds. Default to 3"

  default = 3
}

variable "environment" {
  type = list(object({
    variables = map(string)
  }))
  description = "Map of environment variables that are accessible from the function code during execution."

  default = []
}

variable "vpc_config" {
  type = list(object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  }))
  description = "For network connectivity to AWS resources in a VPC, specify a list of security groups and subnets in the VPC"

  default = []
}

variable "log_retention" {
  type        = number
  description = "Lambda Cloudwatch logs retention policy. Defaults to 7 days"

  default = 7
}

variable "lambda_additional_policies" {
  type        = map(string)
  description = "A map, containing custom Lambda policies granting necessary permissions to the Lambda function, where key represents policy name and value is json policy"

  default = {}
}
