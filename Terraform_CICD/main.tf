terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}
provider "aws" {
    region = var.region
  
}
module "ec2_instance" {
  source        = "github.com/nikhilpatil027/Terraform_code_Nikhil_Patil/Terraform_CICD/ec2_creation"
  region        = var.region
  instance_type = var.instance_type
}
