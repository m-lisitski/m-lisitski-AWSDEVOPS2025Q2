provider "aws" {
  region = var.aws_default_region
  default_tags {
    tags = {
      Owner = "tf-rs-school"
    }
  }
}

import {
  id = "vpc-06bb7522670dea357"
  to = aws_default_vpc.default
}

resource "aws_default_vpc" "default" {}
