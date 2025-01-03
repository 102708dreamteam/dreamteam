
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "dreamteam" {
  bucket = "Dreamteam"
}

resource "aws_instance" "web" {
  ami           = "ami-0004eadf6718241f0"  # Replace with your preferred AMI
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.web_profile.name

  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "travel"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "web_role" {
  name = "web_role"

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
  role       = aws_iam_role.web_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "web_profile" {
  name = "web_profile"
  role = aws_iam_role.web_role.name
}

resource "aws_route53_zone" "main" {
  name = "travel.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_instance.web.public_dns
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = false
  }
}
