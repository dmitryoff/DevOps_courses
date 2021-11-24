resource "aws_lb" "alb" {
  name               = "alb-terraform"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false
  subnets   = [aws_subnet.public_1_terraform.id, aws_subnet.public_2_terraform.id]
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_terraform.id

  health_check {
    matcher = "200,403" 
  }
}

resource "aws_lb_target_group" "test2" {
  name     = "tf-example-lb-tg-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_terraform.id
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.instance_terraform.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.test2.arn
  target_id        = aws_instance.instance_terraform.id
  port             = 8000
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_listener_rule" "gatsby" {
  listener_arn = aws_lb_listener.alb.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test2.arn
  }

  condition {
    host_header {
      values = ["gatsby.dmitryoff.ru"]
    }
  }
}


resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-terraform"
  description = "OPEN"
  vpc_id      = aws_vpc.vpc_terraform.id

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
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "gat" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.alb_sg.id
}