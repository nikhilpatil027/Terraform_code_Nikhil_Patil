
provider "aws" {
  access_key = ""
  secret_key = ""
  region = var.Variable
}

variable "Variable" {
 default = "ap-south-1"
 description = "The default region"
}

terraform {
  backend "s3" {
    region = "ap-south-1"
    bucket = "terraform-bucket-nikhil"
    key = "state.tfstate"
    encrypt = true
    dynamodb_table = "DB-table-nikhil"
  }
}

locals {

  env="${terraform.workspace}"

  counts = {
    "default"=1
    "prod"=2
    "dev"=2
    "staging"=2
  }

  instances = {
    "default"="t2.micro"
    "prod"="t3.medium"
    "dev"="t2.micro"
    "staging"="t3.small"
  }

  tags = {
    "default"="webserver-def"
    "prod"="webserver-prod"
    "dev"="webserver-dev"
    "staging"="webserver-stag"
  }


  instance_type="${lookup(local.instances,local.env)}"
  count="${lookup(local.counts,local.env)}"
  mytag="${lookup(local.tags,local.env)}"
 
}


resource "aws_instance" "my_work" {
 ami="ami-0dee22c13ea7a9a67"
 instance_type="${local.instance_type}"
 count="${local.count}"
 tags = {
    Name="${local.mytag}"
 }

}
