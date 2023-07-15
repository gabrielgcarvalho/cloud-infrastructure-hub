terraform {

  backend "s3" {
    acl            = "bucket-owner-full-control"
    bucket         = "cloud-infrastructure-hub-terraform-state"
    dynamodb_table = "cloud-infrastructure-hub-terraform-state-lock"
    encrypt        = true
    key            = "cloud-infrastructure-hub/backend/terraform.tfstate"
    region         = "us-east-2"
  }
}

# Default provider
provider "aws" {
  region = "us-east-2"
}
