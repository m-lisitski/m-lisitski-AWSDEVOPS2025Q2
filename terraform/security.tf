# Default Network ACL for VPC 10.0.0.0/16
resource "aws_default_network_acl" "default_10" {
  default_network_acl_id = aws_vpc.vpc_10.default_network_acl_id
  tags = {
    Name = "rs-default_10"
  }
}
# Default  Security Group for VPC 10.0.0.0/16
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc_10.id
  tags = {
    Name = "rs-default_10"
  }
}

# Public NACL for VPC 10.0.0.0/16
resource "aws_network_acl" "public_10" {
  vpc_id     = aws_vpc.vpc_10.id
  subnet_ids = values(aws_subnet.public_10)[*].id
  tags = {
    Name = "rs-public_10"
  }
}

resource "aws_network_acl_rule" "ingress_publict_10" {
  network_acl_id = aws_network_acl.public_10.id
  egress         = false

  for_each    = var.public_ingress_nacl_rules_10
  rule_number = each.value.rule_number
  protocol    = each.value.protocol
  rule_action = each.value.rule_action
  cidr_block  = each.value.cidr_block
  from_port   = each.value.from_port
  to_port     = each.value.to_port
}

resource "aws_network_acl_rule" "egress_public_10" {
  network_acl_id = aws_network_acl.public_10.id
  egress         = true

  for_each    = var.public_egress_nacl_rules_10
  rule_number = each.value.rule_number
  protocol    = each.value.protocol
  rule_action = each.value.rule_action
  cidr_block  = each.value.cidr_block
  from_port   = each.value.from_port
  to_port     = each.value.to_port
}

# Private NACL for VPC 10.0.0.0/16
resource "aws_network_acl" "private_10" {
  vpc_id     = aws_vpc.vpc_10.id
  subnet_ids = values(aws_subnet.private_10)[*].id
  tags = {
    Name = "rs-private_10"
  }
}

resource "aws_network_acl_rule" "ingress_privatet_10" {
  network_acl_id = aws_network_acl.private_10.id
  egress         = false

  for_each    = var.private_ingress_nacl_rules_10
  rule_number = each.value.rule_number
  protocol    = each.value.protocol
  rule_action = each.value.rule_action
  cidr_block  = each.value.cidr_block
  from_port   = each.value.from_port
  to_port     = each.value.to_port
}

resource "aws_network_acl_rule" "egress_private_10" {
  network_acl_id = aws_network_acl.private_10.id
  egress         = true

  for_each    = var.private_egress_nacl_rules_10
  rule_number = each.value.rule_number
  protocol    = each.value.protocol
  rule_action = each.value.rule_action
  cidr_block  = each.value.cidr_block
  from_port   = each.value.from_port
  to_port     = each.value.to_port
}


# Public Security Groups for VPC 10.0.0.0/16
resource "aws_security_group" "public_10" {
  description = "Allow public inbound traffic and outbound traffic"
  vpc_id      = aws_vpc.vpc_10.id
  name        = "rs-public_10"

  tags = {
    Name = "rs-public_10"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_10" {
  security_group_id = aws_security_group.public_10.id
  for_each          = var.public_ingress_sg_rules_10
  ip_protocol       = each.value.ip_protocol
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  tags = {
    Name = "rs-public_10"
  }

}

resource "aws_vpc_security_group_egress_rule" "public_10" {
  security_group_id = aws_security_group.public_10.id
  for_each          = var.public_egress_sg_rules_10
  ip_protocol       = each.value.ip_protocol
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  tags = {
    Name = "rs-public_10"
  }

}

# Private Security Groups for VPC 10.0.0.0/16
resource "aws_security_group" "private_10" {
  description = "Allow internal inbound traffic and outbound traffic"
  vpc_id      = aws_vpc.vpc_10.id
  name        = "rs-private_10"

  tags = {
    Name = "rs-private_10"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_10" {
  security_group_id = aws_security_group.private_10.id
  for_each          = var.private_ingress_sg_rules_10
  ip_protocol       = each.value.ip_protocol
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  tags = {
    Name = "rs-private_10"
  }

}

resource "aws_vpc_security_group_egress_rule" "private_10" {
  security_group_id = aws_security_group.private_10.id
  for_each          = var.private_egress_sg_rules_10
  ip_protocol       = each.value.ip_protocol
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  tags = {
    Name = "rs-private_10"
  }
}


