resource "aws_kms_key" "dynamo_encryption" {
  enable_key_rotation = true

  tags = merge(
    local.tags,
    {
      Name = "dynamo_encryption"
    }
  )
}

resource "aws_kms_alias" "dynamo_encryption" {
  name          = "alias/dynamodb-state-lock"
  target_key_id = aws_kms_key.dynamo_encryption.id
}

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
    kms_key_arn = aws_kms_key.dynamo_encryption.arn
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = local.tags
}
