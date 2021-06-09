# terraforest-lambda

<p align="center">
  <img width="198" height="141" src="./img/logo.png">
</p>
Terraform module for AWS Lambda function and its supporting resources.

# Usage

Create a simple AWS Lambda function

```hcl
module "codecommit_job" {
  source  = "git::https://github.com/jevjay/terraforest-lambda.git?ref=v0.0.1"

  name = "my-function"
  runtime  = "go1.x"
  lambda_source_file        = "./path/to/file"
}
```

# Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | AWS Lambda function name | string | n/a | yes |
| runtime | AWS Lambda runtime type and version | string | n/a | yes |
| lambda\_source\_file | AWS Lambda function package/binary path, which will be archived and uploaded as the Lambda source | string | n/a | yes |
| lambda\_source\_dir | AWS Lambda function package directory path, which will be archived and uploaded as the Lambda source | string | "" | no |
| lambda\_source\_excludes | Specify files to ignore when reading the Lambda source directory. Requires `lambda_source_dir` variable | list(any) | [] | no |
| memory\_size | Amount of memory in MB your Lambda Function can use at runtime | number | 128 | no |
| timeout | Amount of time your Lambda Function has to run in seconds | number | 3 | no |
| environment | Map of environment variables that are accessible from the function code during execution | list(object) | [] | no |
| vpc\_config | For network connectivity to AWS resources in a VPC, specify a list of security groups and subnets in the VPC | list(object) | [] | no |
| log\_retention | Lambda Cloudwatch logs retention policy in days | number | 7 | no |
| lambda\_additional\_policies | A map, containing custom Lambda policies granting necessary permissions to the Lambda function, where key represents policy name and value is json policy | map(string) | \{\} | no |

# Outputs

| Name | Description |
|------|-------------|
| lambda\_arn | Created AWS Lammbda function ARN value |

## Authors

Originally created by [Jev Jay](https://github.com/jevjay)
Module managed by [Jev Jay](https://github.com/jevjay).

## License

Apache 2.0 licensed. See `LICENSE.md` for full details.
