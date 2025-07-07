variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "alb_certificate" {
  type = string
}

variable "vpc_id" {}
variable "subnet_ids" {}
variable "security_group_id" {}
variable "execution_role_arn" {}
variable "ecr_repository_url" {}