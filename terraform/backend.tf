terraform {
  backend "s3" {
    bucket = "tf-rs-school"
    key    = "terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
  }
}

resource "aws_s3_bucket" "tf_backend" {
  bucket              = "tf-rs-school"
  object_lock_enabled = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
}