data "aws_iam_policy" "admin_role" {
  count = length(var.aws_common_admin_policies)
  name  = var.aws_common_admin_policies[count.index]
}

data "aws_ec2_managed_prefix_list" "vpc_10_ec2_console_access" {
  name = "com.amazonaws.${aws_vpc.vpc_10.region}.ec2-instance-connect"
}
