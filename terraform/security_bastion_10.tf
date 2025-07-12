

resource "aws_security_group" "bastion_10" {
  description = "Allow public inbound traffic and outbound traffic"
  vpc_id      = aws_vpc.vpc_10.id
  name        = "rs-bastion-10"
  tags        = var.bastion_instance_config.tags
}

resource "aws_vpc_security_group_ingress_rule" "ssh_bastion_10" {
  security_group_id = aws_security_group.bastion_10.id

  count       = length(var.bastion_10_ssh_allowed_cidrs)
  ip_protocol = "tcp"
  cidr_ipv4   = var.bastion_10_ssh_allowed_cidrs[count.index]
  from_port   = "22"
  to_port     = "22"
  tags        = var.bastion_instance_config.tags
}

resource "aws_vpc_security_group_ingress_rule" "bastion_console_access" {
  security_group_id = aws_security_group.bastion_10.id

  ip_protocol    = "tcp"
  prefix_list_id = data.aws_ec2_managed_prefix_list.vpc_10_ec2_console_access.id
  from_port      = "22"
  to_port        = "22"
  tags           = var.bastion_instance_config.tags
}
