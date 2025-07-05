variable "k3s_instance_config" {
  description = "AMI for the bastion host configuration"
  type = object({
    ami              = string
    architecture     = string
    instance_type    = string
    os_name          = string
    ssh_pub_key_path = string
    tags             = map(string)
  })
  default = {
    ami              = "ami-020cba7c55df1f615"
    architecture     = "x86_64"
    instance_type    = "t2.medium"
    os_name          = "Ubuntu 24.04 LTS"
    ssh_pub_key_path = ".ssh/id_rsa"
    tags = {
      Name = "rs-k3s-10"
    }
  }
}