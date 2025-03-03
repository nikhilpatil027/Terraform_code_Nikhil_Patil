provider "aws" {
  access_key = ""
  secret_key = ""
  region = "ap-south-1"  
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners      = ["amazon"] 

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


locals {
  common_tags = {
    Project     = "Terraform-EC2-Deployment"
    BU = "Development"
    Team   = "Devops"
  }
  creation_time = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
}

resource "aws_instance" "dev_instance" {
  ami           = data.aws_ami.ubuntu_latest.id
  instance_type = var.instance_type

  subnet_id = element(data.aws_subnets.default_subnets.ids, 0)

  tags = merge(
    local.common_tags,
    {
      Name         = "dev-Instance"
      CreationTime = local.creation_time
    }
  )
}


output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.dev_instance.id
}

output "instance_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.dev_instance.public_ip
}

output "ami_used" {
  description = "AMI ID of the EC2 instance"
  value       = data.aws_ami.ubuntu_latest.id
}