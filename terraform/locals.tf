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

