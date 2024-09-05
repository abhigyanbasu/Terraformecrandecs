# Declare the AWS provider
provider "aws" {
  region = "ap-south-1"  # Specify your desired AWS region
}

terraform {
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "abhigyan-terraform-backend"
    key    = "ecr/terraform.tfstate"
    region = "ap-south-1" 

     
    # For State Locking
    dynamodb_table = "terraform-state-table"    
  
  }
}
# Declare a variable for the repository name
variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "my-default-ecr-repo"  # Provide a default value if desired
}

# Create the ECR repository using the variable
resource "aws_ecr_repository" "$${var.ecr_repo_name}" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"  # Options: MUTABLE, IMMUTABLE
}



  

# Output the repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.this.repository_url
  description = "The URL of the ECR repository"
}