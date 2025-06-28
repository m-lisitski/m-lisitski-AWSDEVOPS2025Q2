resource "aws_key_pair" "k3s_10" {
  key_name   = "k3s-10"
  public_key = tls_private_key.ssh_10.public_key_openssh
  tags       = var.k3s_instance_config.tags
}

resource "aws_instance" "control_plane_k3s_10" {
  ami                    = var.k3s_instance_config.ami
  instance_type          = var.k3s_instance_config.instance_type
  subnet_id              = aws_subnet.private_10[local.az_1a].id
  vpc_security_group_ids = [aws_security_group.private_10.id]
  key_name               = aws_key_pair.k3s_10.key_name

  tags = {
    Name = "rs-control-plane-10"
  }

  private_ip = cidrhost(aws_subnet.private_10[local.az_1a].cidr_block, 10)

  user_data = file("./user_data/control_plane_k3s.sh")
}

resource "aws_instance" "node_k3s_10" {
  ami                    = var.k3s_instance_config.ami
  instance_type          = var.k3s_instance_config.instance_type
  subnet_id              = aws_subnet.private_10[local.az_1b].id
  vpc_security_group_ids = [aws_security_group.private_10.id]
  key_name               = aws_key_pair.k3s_10.key_name

  tags = {
    Name = "rs-node-10"
  }

  private_ip = cidrhost(aws_subnet.private_10[local.az_1b].cidr_block, 11)

  user_data = templatefile("${path.module}/user_data/node_k3s.tftpl", {
    ssh_private_b64  = local.ssh_private_b64,
    home_path        = local.home_path,
    control_plane_ip = aws_instance.control_plane_k3s_10.private_ip,
  })

  depends_on = [aws_instance.control_plane_k3s_10]
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
