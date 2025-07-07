
resource "aws_ecs_cluster" "client" {
  name = "${var.project_name}-cluster-client-terraform"
}

resource "aws_cloudwatch_log_group" "ecs_client_logs" {
  name              = "/ecs/${var.project_name}-client-terraform"
  retention_in_days = 30

  tags = {
    Environment = var.environment
    Service     = "${var.project_name}-client-terraform"
  }
}

resource "aws_ecs_task_definition" "client" {
  family                   = "${var.project_name}-client-terraform"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "notangles"
      image     = "${var.ecr_repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project_name}-client-terraform"
          awslogs-region        = "ap-southeast-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_lb" "client_alb" {
  name               = "${var.project_name}-client-alb-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids

  tags = {
    Environment = var.environment
    Service     = "${var.project_name}-client-terraform"
  }
}

resource "aws_lb_target_group" "client_tg" {
  name        = "${var.project_name}-client-tg-terraform"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Environment = var.environment
    Service     = "${var.project_name}-client-terraform"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.client_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.client_tg.arn
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.client_alb.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn   = var.alb_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.client_tg.arn
  }
}

resource "aws_ecs_service" "client" {
  name            = "${var.project_name}-client-service-terraform"
  cluster         = aws_ecs_cluster.client.id
  task_definition = aws_ecs_task_definition.client.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnet_ids
    assign_public_ip = true
    security_groups  = [var.security_group_id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.client_tg.arn
    container_name   = "notangles"
    container_port   = 80
  }
}
