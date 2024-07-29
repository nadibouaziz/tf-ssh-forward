terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "eu-west-1"
  profile = "terraform"
}

resource "aws_instance" "forward_ssh" {
  # change using data latest ami free tier
  ami                    = data.aws_ami.amzn2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = aws_key_pair.tf_ec2_rsa_pem.key_name
}

# EC2 instance Security Group
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Allow SSH inbound traffic"

  # Allow SSH inbound for allowed IP addressess (in this case my IP only)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.ifconfig_co_json.ip}/32"]
  }

  # Outbound all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create RSA key of size 4096 bits
resource "tls_private_key" "tf_ec2_rsa_pem" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create local file
resource "local_file" "tf_ec2_rsa_pem" {
  content  = tls_private_key.tf_ec2_rsa_pem.private_key_pem
  filename = "${path.module}/tf_ec2_rsa_pem.pem"
}

# Create AWS key pair
resource "aws_key_pair" "tf_ec2_rsa_pem" {
  key_name   = "tf_ec2_rsa_pem"
  public_key = tls_private_key.tf_ec2_rsa_pem.public_key_openssh
}

