locals {

  file_config = try(yamldecode(file(var.config))["config"], [])
  raw_config  = yamldecode(var.raw_config)["config"]
  # Overwrite configurations (if applicable)
  config = length(local.raw_config) > 0 ? local.raw_config : local.file_config

  # === LAMBDA CONFIG ===

  lambda = flatten([
    for config in local.config : {

      function_name           = config.name
      handler                 = config.handler
      runtime                 = config.runtime
      source                  = config.source
      architectures           = lookup(config, "architectures", ["x86_64"])
      code_signing_config_arn = lookup(config, "code_signing_config_arn", null)
      description             = lookup(config, "description", "")
      memory                  = lookup(config, "memory", 128)
      timeout                 = lookup(config, "timeout", 3)
      variables = {
        for i in local.variables : i.name => i.value if i.function_name == config.name
      }
      vpc = [
        for i in local.vpc_config : {
          subnet_ids         = i.subnet_ids
          security_group_ids = i.security_group_ids
        } if i.function_name == config.name
      ]
      permissions = [
        for i in local.permissions : {
          role   = i.role
          path   = i.path
          policy = i.policy
        }
      ]
      logs = [
        for i in local.logs : {
          group_name = i.group_name
          retention  = i.retention
        } if i.function_name == config.name
      ]
    }
  ])

  # === ENVRIONMENT VARIABLES ===

  variables = flatten([
    for config in local.config : [
      for variable in lookup(config, "variables", []) : {
        function_name = config.name
        name          = variable.name
        value         = variable.value
      }
    ]
  ])

  # === VPC CONFIG ===

  vpc_config = flatten([
    for config in local.config : {
      function_name      = config.name
      subnet_ids         = lookup(config.vpc, "subnet_ids", [])
      security_group_ids = lookup(config.vpc, "security_group_ids", [])
  }])

  # === PERMISSIONS CONFIG ===

  permissions = flatten([
    for config in local.config : {
      function_name = config.name
      role          = lookup(config.permissions, "role", config.name)
      path          = lookup(config.permissions, "path", "/terrabits/lambda/")
      policy        = lookup(config.permissions, "policy", "")
    }
  ])

  # === LOGS ===

  logs = flatten([
    for config in local.config : {
      function_name = config.name
      group_name    = lookup(config.logs, "group_name", "/aws/lambda/${config.name}")
      retention     = lookup(config.logs, "retention", 7)
    }
  ])

  tags = merge(var.shared_tags, {
    Terraformed = true
  })
}
