terraform {
  backend "s3" {
    acl                  = "bucket-owner-full-control"
    bucket               = "cloud-infrastructure-hub-terraform-state"
    dynamodb_table       = "cloud-infrastructure-hub-terraform-state-lock"
    encrypt              = true
    key                  = "terraform.tfstate"
    workspace_key_prefix = "environments/accounts/example" # This will store the object as environments/accounts/example/${workspace}/terraform.tfstate
    region               = "us-east-2"
  }
}
