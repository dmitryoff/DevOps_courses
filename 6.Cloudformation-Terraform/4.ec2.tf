resource "aws_instance" "instance_1" {
  subnet_id   = aws_subnet.public_1.id
  ami           = "ami-08edbb0e85d6a0a07" 
  instance_type = "t2.micro"
  key_name = "newkey"
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
  key_name = "newkey"
  vpc_security_group_ids = [
    aws_security_group.allow_tls.id
  ]

  tags = { 
    Name = "second instance terraform" 
  }
}

resource "aws_key_pair" "keyterraform" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6xpKLIKSfCAv/v3kD56FTo23UySCTuLlnlaBw9QYekOfGNDmysuMXoutXP50Pya1CJoXqTRgCTv+igq30WTbC/d9ZQRja19R583iQmVmVh8QZGHHM0X8SbUVP2csQi7BxtZgeVlKo0WFBndZfkjx1RvY5bYwPN3xoB1GikfIZslorDNOLNfyOWHPqTX5/1xKTnNshj8gHp1fOkuShxhANZtGGYlesR560+8R/UAH7TKJRHFuZA6QaVxCn0PIcEpRV8/o5UmWMANvaq449l4S9ehTJfFw0joMu5E1mQKsBXKaNgrGc/5Dk4V6gIIJSWuHqnnYpGCqs9AhURvBuVEc8kNYtd4HgmNYNjF90w8KyZkHKaER5FZwprAYuc53REvWIGHn3qOFz9L5x9/ezEL2tBCSrv2bvpxtu/UxqmIapjGXhCJFxyTjFe+zi+KxkLCtW73dswQY8D+l6DvSsR6l4Wo1jr0GG7WpeycwLGBzDgdm0q8E/6xx2GnPg5YL98mc= dmitry@dmitry-B450M-S2H"
}
