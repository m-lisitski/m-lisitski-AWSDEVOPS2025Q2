output "tf_s3_backend" {
  description = "Name of the AWS S3 bucket used as the Terraform backend"
  value = {
    name       = aws_s3_bucket.tf_backend.id
    region     = aws_s3_bucket.tf_backend.region
    versioning = aws_s3_bucket_versioning.tf_backend.versioning_configuration[0].status
    locking    = aws_s3_bucket_object_lock_configuration.tf_backend.object_lock_enabled
  }
}

output "github_actions_env_vars" {
  description = "AWS variables to configure GitHub Actions for applying Terraform"
  value = {
    AWS_REGION                  = var.aws_default_region
    AWS_GITHUB_ACTIONS_ROLE_ARN = aws_iam_role.github_actions.arn
  }
}

output "vpc_10_configuration" {
  description = "Details of the VPC with CIDR block 10.0.0.0/16"
  value       = var.vpc_10_config
}

output "bastion_10_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_eip.bastion_10.public_ip
}

output "control_plane_k3s_10" {
  value = {
    "availability_zone" = aws_instance.control_plane_k3s_10.availability_zone,
    "private_ip"        = aws_instance.control_plane_k3s_10.private_ip
  }
}
output "node_k3s_10" {
  value = {
    "availability_zone" = aws_instance.node_k3s_10.availability_zone,
    "private_ip"        = aws_instance.node_k3s_10.private_ip
  }
}
