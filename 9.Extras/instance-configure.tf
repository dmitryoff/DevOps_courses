provider "aws" {
    region = "eu-west-1"
}

resource "aws_vpc" "vpc_terraform" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-from-terraform"
  }
}

resource "aws_internet_gateway" "gw-terraform" {
  vpc_id = aws_vpc.vpc_terraform.id 

  tags = {
    Name = "igw-terraform"
  }
}

resource "aws_subnet" "public_1_terraform" {
  vpc_id     = aws_vpc.vpc_terraform.id 
  cidr_block = "10.0.13.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet_1_terraform"
  }
}

resource "aws_subnet" "public_2_terraform" {
  vpc_id     = aws_vpc.vpc_terraform.id 
  cidr_block = "10.0.14.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet_2_terraform"
  }
}

resource "aws_route_table" "public_terraform" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-terraform.id
  }

  tags = {
    Name = "public_rt_terraform"
  }
}

resource "aws_route_table_association" "public1an" {

  subnet_id = aws_subnet.public_1_terraform.id
  
  route_table_id = aws_route_table.public_terraform.id
}

resource "aws_route_table_association" "public2" {

  subnet_id = aws_subnet.public_2_terraform.id
  
  route_table_id = aws_route_table.public_terraform.id
}


resource "aws_instance" "instance_terraform" {
  subnet_id   = aws_subnet.public_1_terraform.id
  ami           = "ami-080701c09bc0db9f8" 
  instance_type = "t3.medium"
  key_name = "newkey"
  vpc_security_group_ids = [
    aws_security_group.instance_sg.id
  ]

  tags = { 
    Name = "instance terraform" 
  }
}

resource "aws_key_pair" "keyterraform1" {
  public_key = "ssh-rsa "
}

resource "aws_security_group" "instance_sg" {
  name        = "WEB-sg-terraform"
  description = "OPEN"
  vpc_id      = aws_vpc.vpc_terraform.id

  tags = {
    Name = "sg_terraform"
  }
}

resource "aws_security_group_rule" "public_out1" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance_sg.id
}

 resource "aws_security_group_rule" "http_host" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.alb_sg.id}"
 
  security_group_id = aws_security_group.instance_sg.id
}

 resource "aws_security_group_rule" "ssh_host" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.instance_sg.id
}

 resource "aws_security_group_rule" "gatsby" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.alb_sg.id}"
 
  security_group_id = aws_security_group.instance_sg.id
}
