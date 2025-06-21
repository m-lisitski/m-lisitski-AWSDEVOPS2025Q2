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

output "bastion_info_10" {
  description = "AWS 10.0.0.0/16 VPC Bastion Info"
  value = {
    instance_state     = aws_instance.bastion_10.instance_state
    ec2_console_access = tobool(aws_vpc_security_group_ingress_rule.bastion_console_access.id != null)
    public_ip          = aws_eip.bastion_10.public_ip
    private_ip         = aws_instance.bastion_10.private_ip
    public_dns         = aws_instance.bastion_10.public_dns
    ssh_allowed_cidrs  = var.bastion_10_ssh_allowed_cidrs
    ssh_command        = "ssh -i ~/${var.bastion_instance_config.ssh_key_path} ubuntu@${aws_eip.bastion_10.public_ip}"
  }
}

output "subnet_info_10" {
  description = "Subnet Information for VPC 10.0.0.0/16"
  value = {
    public_subnets = {
      for az, subnet in aws_subnet.public_10 : az => {
        subnet_id               = subnet.id
        cidr_block              = subnet.cidr_block
        availability_zone       = subnet.availability_zone
        map_public_ip_on_launch = subnet.map_public_ip_on_launch
      }
    }
    private_subnets = {
      for az, subnet in aws_subnet.private_10 : az => {
        subnet_id               = subnet.id
        cidr_block              = subnet.cidr_block
        availability_zone       = subnet.availability_zone
        map_public_ip_on_launch = subnet.map_public_ip_on_launch
      }
    }
  }
}


