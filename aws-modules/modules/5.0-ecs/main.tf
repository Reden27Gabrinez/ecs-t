# ECS Cluster
resource "aws_ecs_cluster" "demo_app_cluster" {
  name = var.demo_app_cluster_name
}

# ECS Task Definition
resource "aws_ecs_task_definition" "demo_app_task" {
  family                   = var.demo_app_task_family
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.demo_app_task_name}",
      "image": "${module.ecr.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.container_port}
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = module.iam.ecs_task_execution_role_arn
}

# ECS Service
resource "aws_ecs_service" "demo_app_service" {
  name            = var.demo_app_service_name
  cluster         = aws_ecs_cluster.demo_app_cluster.id
  task_definition = aws_ecs_task_definition.demo_app_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = module.ingress.alb_target_group_arn
    container_name   = aws_ecs_task_definition.demo_app_task.family
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = module.networking.public_subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.service_security_group.id]
  }
}
