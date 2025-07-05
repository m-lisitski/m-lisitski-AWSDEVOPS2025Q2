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

  user_data = templatefile("${path.module}/user_data/bastion_10.tftpl", {
    ssh_private_b64 = local.ssh_private_b64,
    home_path       = local.home_path
  })
}

resource "aws_eip" "bastion_10" {
  instance   = aws_instance.bastion_10.id
  depends_on = [aws_internet_gateway.igw_10]
  tags       = var.bastion_instance_config.tags
}