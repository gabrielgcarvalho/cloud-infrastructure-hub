locals {
    project = "example"
    env = "dev" 
    region = "us-east-2"

    prefix = "${local.project}/${local.env}"
}