provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "main" {
  name = "travelfreak.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.travelfreak.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web.public_ip]
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with your desired AMI ID
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "WebServer"
  }

  key_name = "dreamteam" # Your key pair name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
