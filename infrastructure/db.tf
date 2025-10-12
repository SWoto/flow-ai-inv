resource "aws_db_subnet_group" "flow_ai_db_subnet_group" {
  name       = "flow-ai-inv-db-subnet-group"
  subnet_ids = [
    aws_subnet.flow_ai_subnet_private_1a.id,
    aws_subnet.flow_ai_subnet_private_1b.id,
    aws_subnet.flow_ai_subnet_private_1c.id
  ]

  tags = {
    Name = "flow-ai-inv-db-subnet-group"
    Tag  = "flow-ai-inv"
  }
}

resource "aws_db_instance" "flow_ai_db" {
  instance_class          = "db.t4g.micro"
  allocated_storage       = 20 
  engine                  = "postgres"
  engine_version          = "17.6" 
  identifier              = "flow-ai-inv-postgres"
  username                = var.db_username
  password                = var.db_password
  db_name                 = "banquinho"
  
  multi_az                = false 
  publicly_accessible     = false 
  
  db_subnet_group_name    = aws_db_subnet_group.flow_ai_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.flow_ai_db_sg.id] # New DB Security Group

  # Optional: For quick testing, you can specify that it should be created
  # in a single, specific subnet (like the private one)
  # subnet_ids = [aws_subnet.flow_ai_subnet_private.id] 

  tags = {
    Name = "flow-ai-inv-postgres"
    Tag  = "flow-ai-inv"
  }
}