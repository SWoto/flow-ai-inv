resource "aws_ecr_repository" "backend" {
  name = "flow-ai-inv-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Project = "FlowAIInventory"
  }
}