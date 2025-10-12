provider "aws" {
  profile = "default"
  region = "sa-east-1"
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