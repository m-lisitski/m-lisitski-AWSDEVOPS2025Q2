resource "aws_vpc" "vpc_10" {
  cidr_block           = local.vpc_10_cidr_block
  enable_dns_support   = var.vpc_10_config.enable_dns_support
  enable_dns_hostnames = var.vpc_10_config.enable_dns_hostnames
  instance_tenancy     = var.vpc_10_config.instance_tenancy
  tags = {
    Name = "rs-10"
  }
}

# Default route table of VPC 10.0.0.0/16
resource "aws_default_route_table" "rt_default_10" {
  default_route_table_id = aws_vpc.vpc_10.default_route_table_id
  tags = {
    Name = "rs-default-10"
  }
}

# Public subnets
resource "aws_internet_gateway" "igw_10" {
  vpc_id = aws_vpc.vpc_10.id
  tags = {
    Name = "rs-10"
  }
}

resource "aws_subnet" "public_10" {

  for_each = local.azs_public_subnets_10

  vpc_id                  = aws_vpc.vpc_10.id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true
  tags = {
    Name = "rs-public-10-${each.key}"
  }
}

resource "aws_route_table" "rt_public_10" {
  vpc_id = aws_vpc.vpc_10.id
  tags = {
    Name = "rs-public-10"
  }
}

resource "aws_route" "r_public_10" {
  route_table_id         = aws_route_table.rt_public_10.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_10.id
}

resource "aws_route_table_association" "subnet_public_10" {
  for_each       = aws_subnet.public_10
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt_public_10.id
}


# Private subnets
resource "aws_eip" "nat_10" {
  depends_on = [aws_internet_gateway.igw_10]
  tags = {
    Name = "rs-nat-10"
  }
}

resource "aws_nat_gateway" "nat_10" {
  allocation_id = aws_eip.nat_10.id
  subnet_id     = aws_subnet.public_10["us-east-1a"].id
  tags = {
    Name = "rs-10"
  }
}

resource "aws_subnet" "private_10" {
  for_each          = local.azs_private_subnets_10
  vpc_id            = aws_vpc.vpc_10.id
  availability_zone = each.key
  cidr_block        = each.value
  tags = {
    Name = "rs-private-10-${each.key}"
  }
}

resource "aws_route_table" "rt_private_10" {
  vpc_id = aws_vpc.vpc_10.id
  tags = {
    Name = "rs-private-10"
  }
}

resource "aws_route" "r_private_10" {
  route_table_id         = aws_route_table.rt_private_10.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_10.id
}

resource "aws_route_table_association" "subnet_private_10" {
  for_each       = aws_subnet.private_10
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt_private_10.id
}

