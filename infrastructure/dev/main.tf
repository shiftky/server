variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "ap-northeast-1"
}

resource "aws_kms_key" "plivo" {
  description = "plivo kms key"
  is_enabled  = true
}

