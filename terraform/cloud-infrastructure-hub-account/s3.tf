resource "aws_kms_key" "s3_terraform_encryption" {
  enable_key_rotation = true

  tags = merge(
    local.tags,
    {
      Name = "s3_terraform_encryption"
    }
  )
}

resource "aws_kms_alias" "s3_terraform_encryption" {
  name          = "alias/s3_terraform-state-lock"
  target_key_id = aws_kms_key.dynamo_encryption.id
}

resource "aws_s3_bucket" "cloud-infrastructure-hub-terraform" {
  bucket = "cloud-infrastructure-hub-terraform-state"

  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloud-infrastructure-hub-terraform" {
  bucket = aws_s3_bucket.cloud-infrastructure-hub-terraform.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_terraform_encryption.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

