
variable "AWSAccessKey" { description = var.environments }
variable "AWSRegion" { description = var.environments}
variable "AWSSecret" {description = var.environments}
variable "cidr_block" {description = var.env }
variable "SubnetRegion" {description = "dev"}
  provider "aws" {
    region = var.AWSRegion
    access_key = var.AWSAccessKey
    secret_key = var.AWSSecret
  }

  resource "aws_vpc" "dev_vpc" {
    cidr_block = var.cidr_block
        tags = {
      Name = "Dev_Vpc_terra" 
    }
  }

  resource "aws_subnet" "dev_subnet1" {
    vpc_id            = aws_vpc.dev_vpc.id
    cidr_block        = var.cidr_block
    availability_zone = var.SubnetRegion
    tags = {
      Name = "subnet-dev-terra1" 
    }
  }
#   data "aws_vpc" "existing_vpc" {
#     default = true
#   }

#   resource "aws_subnet" "dev_subnet2" {
#     vpc_id = data.aws_vpc.existing_vpc.id
#     cidr_block = "172.31.48.0/20"
#     availability_zone = "eu-west-2a"
#     tags = {
#       Name = "subnet-dev-terra2"
#     }
#   }

# output "dev_subnet" {
#   value =  aws_vpc.dev_vpc.id
# }