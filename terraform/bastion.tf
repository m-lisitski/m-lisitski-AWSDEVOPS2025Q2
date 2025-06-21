resource "aws_key_pair" "bastion_10" {
  key_name   = "bastion-10"
  public_key = file("${var.bastion_instance_config.ssh_key_path}.pub")
  tags       = var.bastion_instance_config.tags
}

resource "aws_instance" "bastion_10" {
  ami                         = var.bastion_instance_config.ami
  instance_type               = var.bastion_instance_config.instance_type
  subnet_id                   = aws_subnet.public_10["us-east-1a"].id
  associate_public_ip_address = true
  # Get the first private IP address in the subnet 
  # (AWS reserves the first 3 IP addresses for the subnet)
  private_ip             = cidrhost(aws_subnet.public_10["us-east-1a"].cidr_block, 4)
  vpc_security_group_ids = [aws_security_group.bastion_10.id, aws_security_group.public_10.id]
  key_name               = aws_key_pair.bastion_10.key_name
  tags                   = var.bastion_instance_config.tags
}

resource "aws_eip" "bastion_10" {
  instance   = aws_instance.bastion_10.id
  depends_on = [aws_internet_gateway.igw_10]
  tags       = var.bastion_instance_config.tags
}

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

moved {
  from = aws_vpc_security_group_ingress_rule.ec2_console_access
  to   = aws_vpc_security_group_ingress_rule.bastion_console_access
}


resource "aws_vpc_security_group_ingress_rule" "bastion_console_access" {
  security_group_id = aws_security_group.bastion_10.id

  ip_protocol    = "tcp"
  prefix_list_id = data.aws_ec2_managed_prefix_list.vpc_10_ec2_console_access.id
  from_port      = "22"
  to_port        = "22"
  tags           = var.bastion_instance_config.tags
}

resource "aws_vpc_security_group_ingress_rule" "bastion_10" {
  security_group_id = aws_security_group.bastion_10.id
  ip_protocol       = "-1"
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = "-1"
  to_port           = "-1"
  tags              = var.bastion_instance_config.tags
}

resource "aws_vpc_security_group_egress_rule" "bastion_10" {
  security_group_id = aws_security_group.bastion_10.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "-1"
  to_port           = "-1"
  tags              = var.bastion_instance_config.tags
}
