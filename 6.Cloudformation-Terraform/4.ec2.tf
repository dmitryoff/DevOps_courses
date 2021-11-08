resource "aws_instance" "instance_1" {
  subnet_id   = aws_subnet.public_1.id
  ami           = "ami-08edbb0e85d6a0a07" 
  instance_type = "t2.micro"
  key_name = "dmitry-new"
  vpc_security_group_ids = [
    aws_security_group.allow_tls.id
  ]

  tags = { 
    Name = "first instance terraform" 
  }
}

resource "aws_instance" "instance_2" {
  subnet_id   = aws_subnet.public_2.id
  ami           = "ami-08edbb0e85d6a0a07" 
  instance_type = "t2.micro"
  key_name = "dmitry-new"
  vpc_security_group_ids = [
    aws_security_group.allow_tls.id
  ]

  tags = { 
    Name = "second instance terraform" 
  }
}

resource "aws_key_pair" "keyterraform" {
  public_key = "ssh-rsa ***"
}
