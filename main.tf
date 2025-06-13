provider "aws" {
  region = var.aws_default_region
}

import {
  id = "vpc-06bb7522670dea357"
  to = aws_default_vpc.default
}

resource "aws_default_vpc" "default" {}
