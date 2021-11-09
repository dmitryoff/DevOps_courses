resource "aws_db_subnet_group" "dat" {
  name         = "database subnets"
  subnet_ids   = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  description  = "Subnets for Database Instance"

  tags   = {
    Name = "Database Subnets"
  }
}

resource "aws_db_instance" "database-instance" { 
  identifier = "database-terraform"
  storage_type = "gp2"  
  allocated_storage = 20
  engine = "postgres"
  instance_class = "db.t4g.micro"
  port = "5432"
  db_subnet_group_name = aws_db_subnet_group.dat.name
  username = "dima"
  password = "12345abcde"
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true
  backup_retention_period = 0
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg-terraform"
  description = "db-sg-terraform"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "db_sg_terraform"
  }
}

resource "aws_security_group_rule" "public_out_db" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "db" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.db_sg.id
}