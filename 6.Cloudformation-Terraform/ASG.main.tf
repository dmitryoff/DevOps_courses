resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "terraform-lc"
  image_id      = "ami-06fddcce62b1177c1"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_tls.id]
  key_name = "newkey"  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "keyterraformASG" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6xpKLIKSfCAv/v3kD56FTo23UySCTuLlnlaBw9QYekOfGNDmysuMXoutXP50Pya1CJoXqTRgCTv+igq30WTbC/d9ZQRja19R583iQmVmVh8QZGHHM0X8SbUVP2csQi7BxtZgeVlKo0WFBndZfkjx1RvY5bYwPN3xoB1GikfIZslorDNOLNfyOWHPqTX5/1xKTnNshj8gHp1fOkuShxhANZtGGYlesR560+8R/UAH7TKJRHFuZA6QaVxCn0PIcEpRV8/o5UmWMANvaq449l4S9ehTJfFw0joMu5E1mQKsBXKaNgrGc/5Dk4V6gIIJSWuHqnnYpGCqs9AhURvBuVEc8kNYtd4HgmNYNjF90w8KyZkHKaER5FZwprAYuc53REvWIGHn3qOFz9L5x9/ezEL2tBCSrv2bvpxtu/UxqmIapjGXhCJFxyTjFe+zi+KxkLCtW73dswQY8D+l6DvSsR6l4Wo1jr0GG7WpeycwLGBzDgdm0q8E/6xx2GnPg5YL98mc= dmitry@dmitry-B450M-S2H"
}

resource "aws_autoscaling_group" "terraform" {
  name                      = "asg-terraform"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 2
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  load_balancers = [aws_elb.elb.id]

}

resource "aws_autoscaling_policy" "bat" {
  name                   = ">70"
  policy_type               = "StepScaling"
  adjustment_type        = "ChangeInCapacity"       
  autoscaling_group_name = aws_autoscaling_group.terraform.name
  estimated_instance_warmup = "60"

  step_adjustment {
    scaling_adjustment = 1
    metric_interval_lower_bound = 0
  }

}

resource "aws_cloudwatch_metric_alarm" "greater70" {
  alarm_name          = "terraform-alarm>70"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"

  alarm_actions     = [aws_autoscaling_policy.bat.arn]
}

resource "aws_autoscaling_policy" "s15" {
  name                   = "<15"
  policy_type               = "StepScaling"
  adjustment_type        = "ChangeInCapacity"       
  autoscaling_group_name = aws_autoscaling_group.terraform.name
  estimated_instance_warmup = "0"
  step_adjustment {
    scaling_adjustment = 1
    metric_interval_lower_bound = 0
  }

}

resource "aws_cloudwatch_metric_alarm" "s15" {
  alarm_name          = "terraform-alarm<15"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "15"

  alarm_actions     = [aws_autoscaling_policy.s15.arn]
}