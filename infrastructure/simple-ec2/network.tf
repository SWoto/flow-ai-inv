# VPC
resource "aws_vpc" "flow_ai_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "flow-ai-inv-vpc"
    Tag  = "flow-ai-inv"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "flow_ai_igw" {
  vpc_id = aws_vpc.flow_ai_vpc.id

  tags = {
    Name = "flow-ai-inv-igw"
    Tag  = "flow-ai-inv"
  }
}

# Public Subnet
resource "aws_subnet" "flow_ai_subnet_public" {
  vpc_id                  = aws_vpc.flow_ai_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Instances in this subnet get a public IP

  tags = {
    Name = "flow-ai-inv-subnet-public"
    Tag  = "flow-ai-inv"
  }
}

# Route Table
resource "aws_route_table" "flow_ai_route_table" {
  vpc_id = aws_vpc.flow_ai_vpc.id

  route {
    cidr_block = "0.0.0.0/0"        # Allow all outbound traffic
    gateway_id = aws_internet_gateway.flow_ai_igw.id
  }

  tags = {
    Name = "flow-ai-inv-route-table"
    Tag  = "flow-ai-inv"
  }
}

# Route Table Association (Link the subnet to the route table)
resource "aws_route_table_association" "flow_ai_route_association" {
  subnet_id      = aws_subnet.flow_ai_subnet_public.id
  route_table_id = aws_route_table.flow_ai_route_table.id
}