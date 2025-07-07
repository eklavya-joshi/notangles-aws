variable "project_name" {
  type        = string
  default     = "notangles"
}

variable "environment" {
  type        = string
  default     = "production"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "github_repo_name" {
  description = "GitHub repository name for OIDC trust"
  type        = string
  default     = "eklavya-joshi/deployment"
}

variable "alb_certificate" {
  description = "ALB certificate ARN for HTTPS access"
  type        = string
}
