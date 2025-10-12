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
