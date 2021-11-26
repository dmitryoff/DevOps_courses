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

resource "aws_key_pair" "keyterraform" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDxp+pGRiGtO0BKjeh6NWdhXeEELp7au8KIq6peyEESYxhxmbV///WQEE44il8+vHTyMOUDmjjCxOvIPHm7jnG04MX+tf6x83t8qGV2IJeM4aRzcti5PYpgdlpofH5L8OSoA0bPTUPx3QSTWqsFhwH0dz81MNeDqdLNCwH9Ak2MIBJYI2nLlHXiJOAgqE+HF+RtlZvCLUT+4fMEMLOuJ2K4PVqGtPT2/OEGiQAcOZ4Z46Ks/qwcd7X8AyC9ObUoHsyyak0W3556ZieNL1SAV3SO13Z2kiefwM5KifGbqUS5kSddzYifb7cL+bhJ1d2suewnbifSoCfs/rm98trbCK5sDkWXy6/n9SUBc2kNfoi60GGIlOelyGKLMDECUsM9ZTUIB2rQ9Uhs2b4BbqGQ3mMN507jB6xzDkXR45/LwYyScFhJUsXgIYs7MsAbQ/xaHegKS0hV8S0EXs38ZTGQZl/GGbPX1YzERsD2yPoUSSZok+yuJbmmZngYTH77/6VnURs= dmitry@dmitry-B450M-S2H"
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