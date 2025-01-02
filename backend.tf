terraform {
  backend "s3" {
    bucket = "dreamteam"
    key    = "terraform/state/terraform.tfstate"
    region = "us-east-1"
  }
}
