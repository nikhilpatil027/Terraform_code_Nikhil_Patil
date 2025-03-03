provider "aws" {
  
  AWS_ACCESS_KEY_ID="xxxxxxxx"
  AWS_SECRET_ACCESS_KEY="xxxxxx"
  region     = "ap-south-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0dee22c13ea7a9a67"
  instance_type = "t2.micro"
  tags = {
    Name = "EC2_Instance"
  }
}