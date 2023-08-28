#!/bin/bash

# To configure 

# 2. To create an ECR 
aws ecr create-repository --repository-name frontend-ariane 

aws ecr create-repository --repository-name backend-falcon


# 3. Terraform init with backend
terraform init \
  -backend-config="bucket=besedo-terraform-state-bucket" \
  -backend-config="key=iac/terraform.tfstate" \
  -backend-config="region=us-east-1"

# 4. NLB Configuration
 