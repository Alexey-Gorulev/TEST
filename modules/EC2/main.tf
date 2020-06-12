/*
data "aws_ami" "latest_ami_for_ECS" {
  owners      = ["591542846629"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }
}

resource "aws_autoscaling_group" "project" {
  name                      = "ASG-main-server-${var.project}"
  max_size                  = "${var.asg_max_size}"
  min_size                  = "${var.asg_min_size}"
  desired_capacity          = "${var.asg_desired_capacity}"
  vpc_zone_identifier       = "${var.private_subnet_ids}"
  launch_configuration      = aws_launch_configuration.project.name
  health_check_type         = "EC2"
  health_check_grace_period = 600
  default_cooldown          = 600

  tags = [
    {
      key                 = "Environment"
      value               = "${var.env}"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "${var.project}"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${var.project}-K8S-${var.env}"
      propagate_at_launch = true
    },
  ]
}

resource "aws_autoscaling_policy" "CPU-TEST-ScaleUP" {
  name = "ScaleUP"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.project.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarmUP" {
  alarm_name = "TEST-CPU(UP)"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "85"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.project.name}"
  }
alarm_description = "This metric monitor EC2 instance high cpu utilization"
alarm_actions = ["${aws_autoscaling_policy.CPU-TEST-ScaleUP.arn}"]

  tags = {
    Environment = "${var.env}_cpualarmUP"
    Project     = "${var.project}_cpualarmUP"
  }
}

resource "aws_autoscaling_policy" "CPU-TEST-ScaleDOWN" {
  name = "ScaleDOWN"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  autoscaling_group_name = "${aws_autoscaling_group.project.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarmDOWN" {
  alarm_name = "TEST-CPU(DOWN)"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "40"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.project.name}"
  }
  alarm_description = "This metric monitor EC2 instance low cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.CPU-TEST-ScaleDOWN.arn}"]

  tags = {
    Environment = "${var.env}_cpualarmDOWN"
    Project     = "${var.project}_cpualarmDOWN"
  }
}


resource "aws_autoscaling_attachment" "project" {
  autoscaling_group_name = aws_autoscaling_group.project.id
  alb_target_group_arn   = aws_lb_target_group.project.arn
}

resource "aws_launch_configuration" "project" {
  name                 = "${var.project}-MAIN Server"
  image_id             = data.aws_ami.latest_ami_for_ECS.id
  instance_type        = "${var.type_instance}"
  security_groups      = ["${var.sg_id}"]
  iam_instance_profile = "${var.iam_name}"

  user_data = templatefile("./user_data/user_data_ecs.sh.tpl", {
    aws_ecs_cluster = "${var.cluster_name}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "project" {
  name     = "${var.project}-lb-tg"
  port     = "30000"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "project" {
  load_balancer_arn = aws_lb.project.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.project.arn
    type             = "forward"
  }
}

resource "aws_lb" "project" {
  name               = "${var.project}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.sg_id}"]
  subnets            = "${var.public_subnet_ids}"

  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
  }
}
*/
