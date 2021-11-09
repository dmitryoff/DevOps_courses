resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "dima-memcached-terraform"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  subnet_group_name = aws_elasticache_subnet_group.ecsubnetg.name
  security_group_ids = [aws_security_group.ec_sg.id]
}

resource "aws_elasticache_replication_group" "redis" {
  engine               = "redis"
  node_type            = "cache.t2.micro"
  parameter_group_name = "default.redis6.x"
  port                 = 6379
  subnet_group_name = aws_elasticache_subnet_group.ecsubnetg.name
  security_group_ids = [aws_security_group.ec_sg.id]
  availability_zones = ["eu-west-1a", "eu-west-1b"]
  number_cache_clusters         = 2
  replication_group_description = "test description"
  replication_group_id          = "dima-redis-terraform"
}

resource "aws_elasticache_cluster" "replica" {
  cluster_id           = "dima-redis-terraform"
  replication_group_id = aws_elasticache_replication_group.redis.id
}


resource "aws_elasticache_subnet_group" "ecsubnetg" {
  name       = "terraform-cache-subnet"
  subnet_ids = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

resource "aws_security_group" "ec_sg" {
  name        = "ec-sg-terraform"
  description = "ec-sg-terraform"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ec_sg_terraform"
  }
}

resource "aws_security_group_rule" "public_out_ec" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec_sg.id
}

resource "aws_security_group_rule" "ec_m" {
  type              = "ingress"
  from_port         = 11211
  to_port           = 11211
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.ec_sg.id
}

resource "aws_security_group_rule" "ec_r" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.ec_sg.id
}