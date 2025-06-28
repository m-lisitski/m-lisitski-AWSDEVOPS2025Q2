locals {
  vpc_10_cidr_block = var.vpc_10_config.cidr_block
  azs_public_subnets_10 = {
    for idx, az in var.vpc_10_config.availability_zones :
    az => var.vpc_10_config.public_subnets[idx]
  }
  azs_private_subnets_10 = {
    for idx, az in var.vpc_10_config.availability_zones :
    az => var.vpc_10_config.private_subnets[idx]
  }
}

locals {
  ssh_private_b64 = base64encode(tls_private_key.ssh_10.private_key_openssh)
  home_path       = "/home/ubuntu/.ssh/"
}

locals {
  az_1a = var.vpc_10_config.availability_zones[0]
  az_1b = var.vpc_10_config.availability_zones[1]
}