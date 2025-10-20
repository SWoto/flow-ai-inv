variable "db_username" {
  description = "The master username for the PostgreSQL RDS instance."
  type        = string
}

variable "db_password" {
  description = "The master password for the PostgreSQL RDS instance."
  type        = string
  sensitive   = true
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository to grant access to."
  type        = string
}

variable "aws_region" {
  description = "The region code."
  type        = string
}

variable "aws_account_id" {
  description = "The account ID."
  type        = string
  sensitive = true
}