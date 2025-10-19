provider "aws" {
  region = "sa-east-1"
}

terraform {
  backend "s3" {
    bucket         = "flow-ai-terraform-state-bucket"
    key            = "infrastructure/terraform/terraform.tfstate"
    region         = "sa-east-1"
    encrypt        = true                                     
    use_lockfile   = true                                    
  }
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.flow_ai_instance.public_ip
}

output "instance_public_DNS" {
  description = "The public DNS address of the EC2 instance"
  value       = aws_instance.flow_ai_instance.public_dns
}

output "db_instance_address" {
  description = "The address of the PostgreSQL database endpoint"
  value       = aws_db_instance.flow_ai_db.address
}

output "ecr_repository_url" {
  description = "The full URL for the ECR repository."
  value       = aws_ecr_repository.backend_repo.repository_url
}