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
