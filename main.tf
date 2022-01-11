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

resource "aws_s3_bucket" "my-github-actions-bucket1979" {
  bucket = "my-github-actions-bucket1979"
  acl    = "public-read"

  tags = {
    Name        = "GitHubActions"
    Environment = "Dev"
  }

}
resource "aws_instance" "app_server" {
  count         = 3 # Will create 3 EC2 instances
  ami           = "ami-04ad2567c9e3d7893"
  instance_type = "t2.micro"

  tags = {
    Tenable     = "FA"
    Environment = "Dev"
    Name        = "Compute"
  }
}

resource "aws_security_group" "allow_ssh_dev_access2" {
  name        = "allow_ssh_dev_access2"
  description = "Allow SSH access by Development Team"
  vpc_id      = "vpc-5bcd7721"

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow SSH Access from Dev"
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow All Outbound"
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_s3_bucket_policy" "my-github-actions-bucket1979Policy" {
  bucket = "${aws_s3_bucket.my-github-actions-bucket1979.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "my-github-actions-bucket1979-restrict-access-to-users-or-roles",
      "Effect": "Allow",
      "Principal": [
        {
          "AWS": [
            "arn:aws:iam::##acount_id##:role/##role_name##",
            "arn:aws:iam::##acount_id##:user/##user_name##"
          ]
        }
      ],
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.my-github-actions-bucket1979.id}/*"
    }
  ]
}
POLICY
}