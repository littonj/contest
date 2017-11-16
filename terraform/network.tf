provider "aws" {
  region     = "${var.aws_region}"
}

resource "aws_vpc" "acmevpc" {
  cidr_block = "172.28.0.0/16"

  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "AcmeCorp VPC"
  }
}
