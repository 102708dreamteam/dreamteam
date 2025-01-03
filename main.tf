
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "102708dreamteam" {
  bucket = "102708Dreamteam"
}

