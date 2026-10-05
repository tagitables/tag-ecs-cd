variable "aws_region" {
  description = "AWS region used for deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project name used as the resource prefix"
  type        = string
  default     = "tag-flask"
}

variable "vpc_id" {
  description = "VPC used by the ECS service"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets used by the ECS Fargate service"
  type        = list(string)
}