# Data source to fetch your current public IP address 
data "http" "my_ip" { 
  url = "https://ipinfo.io/ip"
}

resource "aws_security_group" "flow_ai_sg" {
  name        = "flow-ai-inv-security-group"
  description = "Allow SSH and HTTP/S traffic"
  vpc_id      = aws_vpc.flow_ai_vpc.id

  # Ingress (Inbound) Rules
  # Allow SSH access from my current ip
  ingress {
    description = "Allow SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${trimspace(data.http.my_ip.response_body)}/32"] 
  }

  # Allow HTTP access from my current ip
  ingress {
    description = "Allow HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${trimspace(data.http.my_ip.response_body)}/32"] 
  }

  # Allow ICMP from my current IP
  ingress {
    description      = "Allow Ping"
    from_port        = 8
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks = ["${trimspace(data.http.my_ip.response_body)}/32"] 
    ipv6_cidr_blocks = []
  }

  # Egress (Outbound) Rule: 
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flow-ai-inv-sg"
    Tag  = "flow-ai-inv"
  }
}


resource "aws_security_group" "flow_ai_db_sg" {
  name        = "flow-ai-inv-db-security-group"
  description = "Allow inbound PostgreSQL traffic from EC2 instance"
  vpc_id      = aws_vpc.flow_ai_vpc.id

  # Ingress Rule: Allow PostgreSQL traffic (port 5432)
  # Source is the EC2's security group ID (Self-Referencing)
  ingress {
    description     = "Allow DB access from EC2 SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.flow_ai_sg.id]
  }

  # Egress Rule: Allow all outbound traffic 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flow-ai-inv-db-sg"
    Tag  = "flow-ai-inv"
  }
}
