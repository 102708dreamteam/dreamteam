
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
iam_instance_profile = aws_iam_instance_profile.arya.name
}

resource "aws_iam_role" "bhushan" {
  name = "bhushan"

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "web_policy_attachment" {
  role       = aws_iam_role.bhushan.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "arya" {
  name = "arya"
  role = aws_iam_role.bhushan.name
}
