terraform {
  backend "s3" {
    bucket = "tf-rs-school"
    key    = "terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
  }
}