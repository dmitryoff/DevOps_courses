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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCn1Ka35J+AadZ3K0m8e0cl8LQFbWtMjfI90wugKcLZEZVBfUB/W6K5lAf5MYx5TOvvzt2KAtUS/d8lULs0pl9ZvZ728DVAC6Rhr98pj+bEeTp4mgPRBI/CP0Ghc0j49TXy/reB76/hiiNiJqnFIjXS+0xBsFNO0XkU+VJoXLB9DaaTHPJqap0+hM0xTYsUC8me5sDJJvsaixpkRQfuA/5p8eX01zGFyFEzNmqzAiD1ybtDGoVIp1YDqJy0TgR8tpzs1dD4xIBZslJ7gpS89OG/47NsjRKbHl2djF3qjFkjYtGSMeHnfkCm+7VqFRYmJWnX4tdTel23GAGxOKMEZb+Qb4OVQz7wywzxGKcVNTwQZq9D/f01/+t0/7T2ab7kSCKmrmG9474clOBKN06iO/I1Ju5+bhRG5mhX/ocnsKNSgamKjXSSdO4vXAFkzHUKci+XqmzgkhySdnXpvIEMU/NpLUBxvweBNAoef8D0RBAcsF5oIg/nS7/ZdVcM+SZQl4E= supranovcih2@gmail.com"
}
