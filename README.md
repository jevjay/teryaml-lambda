![teryaml logo](./img/tbits-logo.png)

# teryaml-lambda

Terraform module for AWS Lambda function and its supporting resources.

# Usage

Create a simple AWS Lambda function

```hcl
module "codecommit_job" {
  source  = "github.com/jevjay/tbits-lambda"

  config = "path/to/configuration"
  shared_tags = {
    SOME = TAG
  }
}
```

## Configuration syntax

You can find an overview of module configuration syntax [here](docs/configuration.md)

## Inputs

You can find an overview of module input variables [here](docs/in.md)

## Outputs

You can find an overview of module output values [here](docs/out.md)

## Authors

Originally created by [Jev Jay](https://github.com/jevjay)
Module managed by [Jev Jay](https://github.com/jevjay).

## License

Apache 2.0 licensed. See `LICENSE.md` for full details.
