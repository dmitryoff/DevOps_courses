provider "aws" {
    region = "eu-west-1"
}

resource "aws_vpc" "vpc_terraform" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-for-site"
  }
}

resource "aws_internet_gateway" "gw-terraform" {
  vpc_id = aws_vpc.vpc_terraform.id 

  tags = {
    Name = "igw-for-site"
  }
}

resource "aws_subnet" "public_1_terraform" {
  vpc_id     = aws_vpc.vpc_terraform.id 
  cidr_block = "10.0.13.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet_1_for_site"
  }
}

resource "aws_subnet" "public_2_terraform" {
  vpc_id     = aws_vpc.vpc_terraform.id 
  cidr_block = "10.0.14.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet_2_for_site"
  }
}

resource "aws_route_table" "public_terraform" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-terraform.id
  }

  tags = {
    Name = "public_rt_for_site"
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
    Name = "instance for site" 
  }
}

resource "aws_key_pair" "keyterraform1" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6xpKLIKSfCAv/v3kD56FTo23UySCTuLlnlaBw9QYekOfGNDmysuMXoutXP50Pya1CJoXqTRgCTv+igq30WTbC/d9ZQRja19R583iQmVmVh8QZGHHM0X8SbUVP2csQi7BxtZgeVlKo0WFBndZfkjx1RvY5bYwPN3xoB1GikfIZslorDNOLNfyOWHPqTX5/1xKTnNshj8gHp1fOkuShxhANZtGGYlesR560+8R/UAH7TKJRHFuZA6QaVxCn0PIcEpRV8/o5UmWMANvaq449l4S9ehTJfFw0joMu5E1mQKsBXKaNgrGc/5Dk4V6gIIJSWuHqnnYpGCqs9AhURvBuVEc8kNYtd4HgmNYNjF90w8KyZkHKaER5FZwprAYuc53REvWIGHn3qOFz9L5x9/ezEL2tBCSrv2bvpxtu/UxqmIapjGXhCJFxyTjFe+zi+KxkLCtW73dswQY8D+l6DvSsR6l4Wo1jr0GG7WpeycwLGBzDgdm0q8E/6xx2GnPg5YL98mc= dmitry@dmitry-B450M-S2H"
}

resource "aws_security_group" "instance_sg" {
  name        = "WEB-sg-terraform"
  description = "OPEN"
  vpc_id      = aws_vpc.vpc_terraform.id

  tags = {
    Name = "sg_for_site"
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
