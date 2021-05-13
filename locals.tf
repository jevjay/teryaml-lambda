locals {
  expanded_name = "${var.name}-${terraform.workspace}"

  common_tags = {
    Application = var.name
    Workspace = terraform.workspace
  }
}
