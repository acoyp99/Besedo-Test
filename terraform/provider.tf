terraform {
  backend "s3" {
    bucket         = "besedo-terraform-state-bucket"  # Replace with your bucket name
    key            = "iac/terraform.tfstate"          # State file key within the bucket
    region         = "us-east-1"                      # AWS region of your bucket
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" 
}