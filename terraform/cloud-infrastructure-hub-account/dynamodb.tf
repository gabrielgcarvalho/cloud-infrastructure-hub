resource "aws_dynamodb_table" "state-lock" {
  name         = "cloud-infrastructure-hub-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.cloud_infrastructure_hub_account_kms.arn
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = local.tags
}
