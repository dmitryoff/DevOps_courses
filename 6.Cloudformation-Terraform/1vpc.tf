provider "aws" {
    region = "eu-west-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-from-terraform"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id 

  tags = {
    Name = "igw-terraform"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.main.id 
  cidr_block = "10.0.13.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet_1_terraform"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.main.id 
  cidr_block = "10.0.14.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet_2_terraform"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.main.id 
  cidr_block = "10.0.15.0/24"
  availability_zone = "eu-west-1a"
  
  tags = {
    Name = "private_subnet_1_terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_rt_terraform"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "private_rt_terraform"
  }
}

resource "aws_route_table_association" "public1" {

  subnet_id = aws_subnet.public_1.id
  
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {

  subnet_id = aws_subnet.public_2.id
  
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {

  subnet_id = aws_subnet.private_1.id
  
  route_table_id = aws_route_table.private.id
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  
  subnet_ids = [
    aws_subnet.private_1.id
  ]

  tags = {
    Name = "aclprivate_terraform"
  }
}

