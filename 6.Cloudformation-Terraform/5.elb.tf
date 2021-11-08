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

  instances                   = [aws_instance.instance_1.id, aws_instance.instance_2.id]
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

  resource "aws_security_group_rule" "elb_in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.elb_sg.id
}