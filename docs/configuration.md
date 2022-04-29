## Configuration syntax

Configurations provided to the module retrieved from a configuration file (YAML-based format) with a following syntax

### Example (basic)

_Note: replace <<>> values with an actual configuration_

```yaml
config:
  - name: << Lambda function name >>
    runtime: << Lambda function runtime >>
    source: << Path to the function source >>
    handler: << Lambda function handler >>
    permissions:
        role: << IAM Role name assumed by Lambda function >>

```

### Overview

#### config

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Unique name for your Lambda Function | string | n/a | yes |
| runtime | Identifier of the function's runtime | string | n/a | yes |
| source | Path to the function's deployment package within the local filesystem | string | n/a | yes |
| handler | Function entrypoint in your code | string | n/a | yes |
| permissions | IAM access configuration. More details bellow... | map | n/a | yes |
| memory | Amount of memory in MB your Lambda Function can use at runtime | int | 128 | no |
| timeout | Amount of time your Lambda Function has to run in seconds | int | 3 | no |
| architectures | Instruction set architecture for your Lambda function | list(string) | ["x86_64"] | no |
| code_signing_config_arn | To enable code signing for this function, specify the ARN of a code-signing configuration | string | n/a | no |
| vpc | VPC configuration block. More details bellow... | map | n/a | no |
| logs | Lambda logging configuration block. More details bellow... | map | n/a | no |
| variables | A map of lambda function used environment variables | list(map) | n/a | no |

#### config.permissions

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| role | IAM role assigned to Lambda function | string | n/a | yes |
| policy | IAM policy managing Lambda function access | string | "" | no |
| path | IAM resources path | string | "/terrabits/lambda/" | no | 

#### config.vpc

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| subnet_ids | A collection of VPC subnet ID(s) used by Lambda function | list(string) | [] | no |
| security_group_ids | A collection of VPC Security group(s) used by Lambda function | list(string) | [] | no |

#### config.logs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| group_name | Cloudwatch log group name used by Lambda function | string | "/aws/lambda/{{ function name }}" | no |
| retention | Cloudwatch log group logs retention in days | int | 7 | no |

#### config.variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Environment variable name (key) | string | n/a | no |
| value | Environment variable value | string | n/a | no |
