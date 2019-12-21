data "aws_ami" "latest_ami_for_ECS" {
  owners      = ["591542846629"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }
}

resource "aws_autoscaling_group" "test" {
  name                 = "${var.env}-asg"
  max_size             = "1"
  min_size             = "1"
  desired_capacity     = "1"
  vpc_zone_identifier  = [aws_subnet.public_subnets[*].id]
  launch_configuration = aws_launch_configuration.test.name
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "${var.env}-ASG-Server"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "test" {
  autoscaling_group_name = aws_autoscaling_group.test.id
  alb_target_group_arn   = aws_lb_target_group.test.arn
}

resource "aws_launch_configuration" "test" {
  name            = "web_lg"
  image_id        = aws_ami.latest_ami_for_ECS.id
  instance_type   = "${var.instance_type_server}"
  security_groups = ["aws_security_group.test.id"]
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  key_name        = "${var.key_name_for_server}"
  user_data = templatefile("user_data.sh.tpl", {
    aws_ecs_cluster = "${aws_ecs_cluster.test.name}",
  })
}

resource "aws_lb" "test" {
  name               = "${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["aws_security_group.test.id"]
  subnets            = aws_subnet.public_subnets[*].id

  tags = {
    Name = "${var.env}-alb"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "${var.env}-lb-tg"
  port     = "${var.port_lb_listener}"
  protocol = "${var.protocol_lb_listener}"
  vpc_id   = aws_vpc.test.id
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.test.arn
  port              = "${var.port_lb_listene}"
  protocol          = "${var.protocol_lb_listener}"

  default_action {
    target_group_arn = aws_lb_target_group.test.arn
    type             = "forward"
  }
}
