locals {
  child_var_file = "${get_terragrunt_dir()}/terragrunt_vars.hcl" # reading terragrunt variables from terragrunt_vars.hcl in a child directory
  vars = read_terragrunt_config(local.child_var_file)
  backend_aws_region = "us-east-2"
  parent_common_yaml = yamldecode(file("${get_parent_terragrunt_dir()}/common.yml")) # reading terragrunt variables from common.yml in a parent directory
}

generate "provider" {
  path      = "auto_provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "aws" {
      region = "${local.vars.locals.region}"
      
      default_tags {
        tags = {
          managed_by = "Terraform",
          env = "${local.vars.locals.env}"
          project = "${local.vars.locals.project}"
        }
      }
    }
  EOF
}

remote_state {
  backend = "s3"
  
  config = {
    bucket  = "cloud-infrastructure-hub-terraform-state"
    acl     = "bucket-owner-full-control"
    encrypt = true
    key     = "cloud-infrastructure-hub/projects/${local.vars.locals.prefix}/terraform.tfstate"
  
    region         = local.backend_aws_region # backend_aws_region variable defined as a local in this terragrunt configuration
    dynamodb_table = local.parent_common_yaml.dynamodb_table # dynamodb_table variable from common.yml in a parent directory
  }

  generate = {
    path      = "terragrunt_backend.tf"
    if_exists = "overwrite_terragrunt"
  }

}