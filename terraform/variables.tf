variable "db_username" {
  description = "The master username for the PostgreSQL RDS instance."
  type        = string
}

variable "db_password" {
  description = "The master password for the PostgreSQL RDS instance."
  type        = string
  sensitive   = true
}