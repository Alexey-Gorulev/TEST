resource "aws_ecs_cluster" "test" {
  name = "test-ecs-cluster"
}

resource "aws_ecs_service" "test" {
  name            = "test-ecs-service"
  cluster         = aws_ecs_cluster.test.id
  task_definition = aws_ecs_task_definition.test.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.test.arn
    container_name   = "test"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
  depends_on = [
    aws_lb.test,
  ]
}

resource "aws_ecs_task_definition" "test" {
  family                = "service"
  container_definitions = file("task-definitions/service.json")

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
