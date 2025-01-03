
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "b-bucket-08"
    key    = "statefile/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "webserver" {
ami = "ami-01816d07b1128cd2d"
instance_type = "t2.micro"
}
