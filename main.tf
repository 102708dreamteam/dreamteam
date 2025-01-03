
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "dreamteam" {
  bucket = "102708Dreamteam"
}

