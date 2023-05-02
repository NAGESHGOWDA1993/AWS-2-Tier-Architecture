#creating terraform providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.57.0"
    }
  }

  required_version = "~> 1.3.0"
}

provider "aws" {
  region = "eu-west-1"
}