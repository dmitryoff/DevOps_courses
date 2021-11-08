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

  resource "aws_security_group_rule" "private_in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.elb_sg.id}"
  

  security_group_id = aws_security_group.allow_tls.id
}

resource "aws_security_group_rule" "private_in_db" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.db_sg.id}"
  

  security_group_id = aws_security_group.allow_tls.id
}