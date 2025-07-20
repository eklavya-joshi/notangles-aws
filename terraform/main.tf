terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "notangles-tf-state-v1"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}


provider "aws" {
  region = "ap-southeast-2"
}

module "network" {
  source       = "./modules/network"
  project_name = var.project_name
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "iam" {
  source           = "./modules/iam"
  project_name     = var.project_name
  aws_account_id   = var.aws_account_id
  github_repo_name = var.github_repo_name
}

module "ecs" {
  source             = "./modules/ecs"
  project_name       = var.project_name
  environment        = var.environment
  aws_account_id     = var.aws_account_id
  alb_certificate    = var.alb_certificate
  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.subnet_ids
  security_group_id  = module.network.security_group_id
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecr_repository_url = module.ecr.repository_url
}
