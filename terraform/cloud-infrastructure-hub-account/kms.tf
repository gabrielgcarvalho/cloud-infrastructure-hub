resource "aws_kms_key" "cloud_infrastructure_hub_account_kms" {
  enable_key_rotation = true

  tags = merge(
    local.tags,
    {
      Name = "cloud_infrastructure_hub_kms"
    }
  )
}

resource "aws_kms_alias" "cloud_infrastructure_hub_account_kms" {
  name          = "alias/cloud_infrastructure_hub_account_kms"
  target_key_id = aws_kms_key.cloud_infrastructure_hub_account_kms.id
}
