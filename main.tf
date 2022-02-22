variable "AWSRegion" { description = "dev" }
variable "AWSSecret" { description = "dev" }
variable "AWSAccessKey" { description = "dev" }
variable "cidr_block" { description = "dev" }
variable "SubnetRegion" { description = "dev" }
variable "my_ip" { description = "dev" }
variable "myami" { description = "dev" }
variable "insta_type" {}
variable "devssh_pub" {}


provider "aws" {
  region     = var.AWSRegion
  secret_key = var.AWSSecret
  access_key = var.AWSAccessKey
}

resource "aws_vpc" "DevVpc" {
  cidr_block = var.cidr_block
  tags = {
    "Name" = "DevVpcTag"
  }
}

resource "aws_subnet" "DevSub" {
  vpc_id            = aws_vpc.DevVpc.id
  cidr_block        = var.cidr_block
  availability_zone = var.SubnetRegion
}

resource "aws_internet_gateway" "DevGateway" {
  vpc_id = aws_vpc.DevVpc.id
  tags = {
    "Name" = "DevGatewatyTag"
  }
}

# vpc_id = aws_vpc.DevVpc.id
resource "aws_default_route_table" "routeTable" {
  default_route_table_id = aws_vpc.DevVpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.DevGateway.id
  }
  tags = {
    "Name" = "RouteTableTag"
  }
}

# resource "aws_route_table_association" "DevAsso" {
#   subnet_id = aws_subnet.DevSub.id
#   route_table_id = aws_route_table.routeTable.id
# }

resource "aws_security_group" "devSG" {
  name   = "DevSG-name"
  vpc_id = aws_vpc.DevVpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    "Name" : "DevSGTag"
  }

}


resource "aws_instance" "devInstance" {
  ami                         = var.myami
  key_name                    = aws_key_pair.dev_key.key_name
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.DevSub.id
  vpc_security_group_ids      = [aws_security_group.devSG.id]
  availability_zone           = var.SubnetRegion
  associate_public_ip_address = true
  user_data = file("app.sh")
  tags = {
    Name : "AWS Instance"
  }
}

resource "aws_key_pair" "dev_key" {
  key_name   = "id_rsa"
  public_key = var.devssh_pub
}
#  ssh -i ~/.ssh/id_rsa ec2-user@52.56.134.89

output "ec2_public_id" {
  value = aws_instance.devInstance.public_ip
}
