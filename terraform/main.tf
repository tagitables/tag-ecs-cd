locals {
  prefix = "${var.project_name}-${var.environment}"
}

# ------------------------------------------------------------
# ECR Repository
# ------------------------------------------------------------

resource "aws_ecr_repository" "ecr" {
  name         = "${local.prefix}-ecr"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${local.prefix}-ecr"
    Environment = var.environment
    Project     = var.project_name
  }
}

# ------------------------------------------------------------
# Security Group for ECS Fargate Tasks
# ------------------------------------------------------------

resource "aws_security_group" "ecs" {
  name        = "${local.prefix}-ecs-sg"
  description = "Security group for ${local.prefix} ECS Fargate tasks"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow Flask application traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.prefix}-ecs-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

# ------------------------------------------------------------
# ECS Cluster, Task Definition and Service
# ------------------------------------------------------------

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 7.5.0"

  cluster_name = "${local.prefix}-ecs"

  cluster_capacity_providers = [
    "FARGATE"
  ]

  services = {
    "${local.prefix}-service" = {
      cpu    = 512
      memory = 1024

      container_definitions = {
        "${local.prefix}-container" = {
          essential = true

          image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${local.prefix}-ecr:latest"

          portMappings = [
            {
              name          = "${local.prefix}-8080-tcp"
              containerPort = 8080
              hostPort      = 8080
              protocol      = "tcp"
            }
          ]
        }
      }

      assign_public_ip = true

      deployment_minimum_healthy_percent = 100

      subnet_ids = var.subnet_ids

      security_group_ids = [
        aws_security_group.ecs.id
      ]
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}