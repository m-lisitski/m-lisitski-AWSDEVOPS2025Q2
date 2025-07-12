variable "vpc_10_config" {
  description = "VPC config"
  type = object({
    cidr_block           = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
    instance_tenancy     = string
    availability_zones   = list(string)
    public_subnets       = list(string)
    private_subnets      = list(string)
  })
  default = {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    instance_tenancy     = "default"
    availability_zones   = ["us-east-1a", "us-east-1b"]
    public_subnets       = ["10.0.1.0/24", "10.0.3.0/24"]
    private_subnets      = ["10.0.2.0/24", "10.0.4.0/24"]
  }
}

variable "bastion_instance_config" {
  description = "AMI for the bastion host configuration"
  type = object({
    ami           = string
    architecture  = string
    instance_type = string
    os_name       = string
    ssh_key_path  = string
    tags          = map(string)
  })
  default = {
    ami           = "ami-020cba7c55df1f615"
    architecture  = "x86_64"
    instance_type = "t2.micro"
    os_name       = "Ubuntu 24.04 LTS"
    ssh_key_path  = ".ssh/id_rsa"
    tags = {
      Name = "rs-bastion-10"
    }
  }
}

variable "bastion_10_ssh_allowed_cidrs" {
  description = "CIDRs allowed to SSH into bastion in VPC 10.0.0.0/16"
  type        = list(string)
  default     = ["31.135.199.147/32"]

}

variable "public_ingress_nacl_rules_10" {
  description = "Public ingress NACL rules"
  type = map(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = string
    to_port     = string
  }))
  default = {
    "ssh_all" = {
      rule_number = 100
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = "22"
      to_port     = "22"
    },
    "http_all" = {
      rule_number = 150
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = "80"
      to_port     = "80"
    },
    "https_all" = {
      rule_number = 200
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = "443"
      to_port     = "443"
    },
    "http_spec_ip" = {
      rule_number = 250
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "31.135.199.147/32"
      from_port   = "80"
      to_port     = "80"
    },
    "flask_app_spec_ip" = {
      rule_number = 255
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "31.135.199.147/32"
      from_port   = "80"
      to_port     = "80"
    },
    "ephemeral_tcp" = {
      rule_number = 300
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = "1024"
      to_port     = "65535"
    },
  }
}

variable "public_egress_nacl_rules_10" {
  description = "Public engress NACL rules"
  type = map(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = string
    to_port     = string
  }))
  default = {
    "all_allow" = {
      rule_number = 200
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = "-1"
      to_port     = "-1"
    },
  }
}

variable "private_ingress_nacl_rules_10" {
  description = "Private ingress NACL rules"
  type = map(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = string
    to_port     = string
  }))
  default = {
    "internal_all_allow" = {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/16"
      from_port   = "-1"
      to_port     = "-1"
    },
  }
}

variable "private_egress_nacl_rules_10" {
  description = "Private egress NACL rules"
  type = map(object({
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = string
    to_port     = string
  }))
  default = {
    "internal_all_allow" = {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = "-1"
      to_port     = "-1"
    },
  }
}

variable "public_ingress_sg_rules_10" {
  description = "Public ingress SG rules"
  type = map(object({
    ip_protocol = string
    cidr_ipv4   = string
    from_port   = string
    to_port     = string
  }))
  default = {
    "http_allow" = {
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = "80"
      to_port     = "80"
    },
    "https_allow" = {
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = "443"
      to_port     = "443"
    },
    "all_allow" = {
      ip_protocol = "-1"
      cidr_ipv4   = "10.0.0.0/16"
      from_port   = "-1"
      to_port     = "-1"
    },
  }
}

variable "public_egress_sg_rules_10" {
  description = "Public engress SG rules"
  type = map(object({
    ip_protocol = string
    cidr_ipv4   = string
    from_port   = string
    to_port     = string
  }))
  default = {
    "all_allow" = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = "-1"
      to_port     = "-1"
    },
  }
}


variable "private_ingress_sg_rules_10" {
  description = "Private ingress SG rules"
  type = map(object({
    ip_protocol = string
    cidr_ipv4   = string
    from_port   = string
    to_port     = string
  }))
  default = {
    "internal_all_allow" = {
      ip_protocol = "-1"
      cidr_ipv4   = "10.0.0.0/16"
      from_port   = "-1"
      to_port     = "-1"
    },
  }
}

variable "private_egress_sg_rules_10" {
  description = "Private egress SG rules"
  type = map(object({
    ip_protocol = string
    cidr_ipv4   = string
    from_port   = string
    to_port     = string
  }))
  default = {
    "internal_all_allow" = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = "-1"
      to_port     = "-1"
    },
  }
}
