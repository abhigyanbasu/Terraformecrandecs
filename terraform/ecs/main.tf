# Declare the AWS provider
provider "aws" {
  region = "ap-south-1"  # Specify your desired AWS region
}

# Declare a variable for the repository name
variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "my-default-ecs"  # Provide a default value if desired
}

# Create the ECR repository using the variable
resource "aws_ecs_cluster" "ecs1" {
  name                 = var.ecs_cluster_name
  
}



  

# outputs.tf
output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.ecs1.name
}