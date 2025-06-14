data "aws_iam_policy" "admin_role" {
  count = length(var.aws_common_admin_policies)
  name  = var.aws_common_admin_policies[count.index]
}
