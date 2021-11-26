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

resource "aws_security_group" "allow_tls" {
  name        = "web-sg-terraform"
  description = "SSH-HTTP-HTTPS"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sg_terraform"
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group_rule" "public_out" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_tls.id
}

  resource "aws_security_group_rule" "private_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
 
  security_group_id = aws_security_group.allow_tls.id
}
  
  resource "aws_security_group_rule" "private_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.elb_sg.id}"
 
  security_group_id = aws_security_group.allow_tls.id
}

resource "aws_elb" "elb" {
  name               = "terraform-elb"
  subnets   = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  security_groups = [
    aws_security_group.elb_sg.id
  ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    target              = "HTTP:80/"
    interval            = 5
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "terraform-elb"
  }
}

resource "aws_security_group" "elb_sg" {
  name        = "elb-sg-terraform"
  description = "elb-sg-terraform"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sg_terraform"
  }
}

resource "aws_security_group_rule" "public_out_elb" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb_sg.id
}

resource "aws_security_group_rule" "elb_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.elb_sg.id
}