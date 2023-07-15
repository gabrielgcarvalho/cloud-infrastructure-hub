resource "aws_s3_bucket" "cloud-infrastructure-hub-terraform" {
  bucket = "cloud-infrastructure-hub-terraform-state"

  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloud_infrastructure_hub_terraform" {
  bucket = aws_s3_bucket.cloud-infrastructure-hub-terraform.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.cloud_infrastructure_hub_account_kms.id
      sse_algorithm     = "aws:kms"
    }
  }
}

