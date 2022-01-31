  provider "aws" {
    region     = "eu-west-2"
    }

  resource "aws_vpc" "dev_vpc" {
    cidr_block = "10.0.0.0/16"
        tags = {
      Name = "Dev_Vpc_terra" 
    }
  }

  resource "aws_subnet" "dev_subnet1" {
    vpc_id            = aws_vpc.dev_vpc.id
    cidr_block        = "10.0.10.0/24"
    availability_zone = "eu-west-2a"
    tags = {
      Name = "subnet-dev-terra1" 
    }
  }
  data "aws_vpc" "existing_vpc" {
    default = true
  }

  resource "aws_subnet" "dev_subnet2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.48.0/20"
    availability_zone = "eu-west-2a"
    tags = {
      Name = "subnet-dev-terra2"
    }
  }
