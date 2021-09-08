provider "aws" {
  region  = var.region
  profile = var.profile
}

data "external" "creator_tag" {
  program = ["aws", "sts", "get-caller-identity"]
}

locals {
  createdby = var.createdby == null ? split("/", data.external.creator_tag.result.Arn)[1] : var.createdby
  tf_ws     = terraform.workspace == "default" ? null : terraform.workspace
}

variable "environment" { default = null }

# This module is used to consistently tag every resource referencing it with module.label.context
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.24.1"
  label_order = ["name", "environment", "attributes"]
  name        = var.name
  environment = var.environment == null ? local.tf_ws : var.environment

  # Caution: using "_" (underscore) as delimiter requires to set s3 and RDS to "-" as those can't accept underscores in names
  delimiter = "-"

  # Don't change label_key_case, AWS requires "Title" in key names
  label_key_case   = "title"
  label_value_case = "lower"

  tags = {
    "CreatedBy"  = local.createdby
    "Deployment" = var.deployment_tags
  }
}
