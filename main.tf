terraform {
  required_providers {
    # Setting the AWS provider and version
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.65.0"
    }
  }
  # Setting the required Terraform version
  required_version = ">= 1.0"
}

# Setting the AWS region we want to use
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  count         = 3 # Will create 3 EC2 instances
  ami           = "ami-04ad2567c9e3d7893"
  instance_type = "t2.micro"

  tags = {
    Tenable     = "FA"
    Environment = "Dev"
  }
}

resource "aws_security_group" "allow_ssh_dev_access" {
  name        = "allow_ssh_dev_access"
  description = "Allow SSH access by Development Team"
  vpc_id      = "vpc-5bcd7721"

  ingress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow SSH Access from Dev"
    from_port = 22
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "tcp"
    security_groups = []
    self = false
    to_port = 22
  } ]

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow All Outbound"
    from_port = 0
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
    to_port = 0
  } ]
  }
