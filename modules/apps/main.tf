# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = join("-", ["ecsTaskExecutionRole", "${var.app_name}"])
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


data "aws_iam_policy_document" "ecs_task_role" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",

    ]
    effect = "Allow"
    resources = ["*"]
  }
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [var.secret_arn]
    effect = "Allow"
  }

}


resource "aws_iam_policy" "ecs_task_role" {
  name        = join("-", ["ecs_task_role", "${var.app_name}"])
  description = "Policy for ECS to push logs to CloudWatch"
  policy      = data.aws_iam_policy_document.ecs_task_role.json
}


resource "aws_iam_role_policy_attachment" "ecs_task_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_role.arn
}

# Create an ECS task definition
resource "aws_ecs_task_definition" "app" {
  family                = var.app_name
  container_definitions =  var.container_definition
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "2048"    // 2 vCPU
  memory                   = "4096"    // 4GB RAM
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

# Create an ECS service
resource "aws_ecs_service" "example" {
  name                               = var.app_name
  cluster                            = var.aws_ecs_cluster
  task_definition                    = aws_ecs_task_definition.app.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  
  deployment_controller {
    type = "ECS"
  }
  network_configuration {
    assign_public_ip = true
    security_groups = [aws_security_group.fargate_instance.id]
    subnets = var.subnets
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.app_name}"
    container_port   = var.app_port
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_role_attachment]
}

resource "aws_lb" "alb" {
  name               = join("-", ["alb", "${var.app_name}"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = var.subnets
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = join("-", ["tg", "${var.app_name}"])
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
  

  health_check {
    interval           = 30
    path               = var.health_path
    timeout            = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Load balancer security group
resource "aws_security_group" "load_balancer" {
  name        = join("-", ["loadbalancer", "${var.app_name}"])
  description = "Load balancer security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Fargate instance security group
resource "aws_security_group" "fargate_instance" {
  name        = join("-", ["fargate", "${var.app_name}"])
  description = "Fargate instance security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    security_groups = [ aws_security_group.load_balancer.id ]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_cloudwatch_log_group" "nginx_log_group" {
  name = join("", ["/ecs/", "${var.app_name}"])
  
  # Optional: Specify retention period (in days) for logs
  retention_in_days = 14

  # Optional: Add tags
  tags = {
    Environment = "production"
    Application = "nginx"
  }
}

resource "aws_ecr_repository" "repository" {
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "production"
  }
}
