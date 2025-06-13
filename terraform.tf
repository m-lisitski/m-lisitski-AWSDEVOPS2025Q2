terraform {
  required_version = "~> 1.12.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "tf-rs-school"
    key    = "terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
  }
}
