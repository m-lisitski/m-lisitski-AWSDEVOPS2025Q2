variable "aws_default_region" {
  description = "AWS default region"
  type        = string
  default     = "us-east-1"
}

variable "aws_common_admin_policies" {
  description = "Commonly Used AWS Policies for Admin Roles"
  type        = list(string)
  default = [
    "AmazonEC2FullAccess",
    "AmazonRoute53FullAccess",
    "AmazonS3FullAccess",
    "IAMFullAccess",
    "AmazonVPCFullAccess",
    "AmazonSQSFullAccess",
    "AmazonEventBridgeFullAccess"
  ]

}