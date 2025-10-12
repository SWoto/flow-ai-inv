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

# Private Subnet
resource "aws_subnet" "flow_ai_subnet_private_1a" {
  vpc_id                  = aws_vpc.flow_ai_vpc.id
  cidr_block              = "10.0.2.0/24" # A different address range
  map_public_ip_on_launch = false 
  availability_zone = "sa-east-1a"

  tags = {
    Name = "flow-ai-inv-subnet-private"
    Tag  = "flow-ai-inv"
  }
}

resource "aws_subnet" "flow_ai_subnet_private_1b" {
  vpc_id                  = aws_vpc.flow_ai_vpc.id
  cidr_block              = "10.0.3.0/24" # A different address range
  map_public_ip_on_launch = false 
  availability_zone = "sa-east-1b"

  tags = {
    Name = "flow-ai-inv-subnet-private"
    Tag  = "flow-ai-inv"
  }
}


resource "aws_subnet" "flow_ai_subnet_private_1c" {
  vpc_id                  = aws_vpc.flow_ai_vpc.id
  cidr_block              = "10.0.4.0/24" # A different address range
  map_public_ip_on_launch = false 
  availability_zone = "sa-east-1c"

  tags = {
    Name = "flow-ai-inv-subnet-private"
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

resource "aws_route_table" "flow_ai_route_table_private" {
  vpc_id = aws_vpc.flow_ai_vpc.id

  tags = {
    Name = "flow-ai-inv-route-table-private"
    Tag  = "flow-ai-inv"
  }
}

resource "aws_route_table_association" "flow_ai_route_association" {
  subnet_id      = aws_subnet.flow_ai_subnet_public.id
  route_table_id = aws_route_table.flow_ai_route_table.id
}

resource "aws_route_table_association" "flow_ai_route_association_private_1a" {
  subnet_id      = aws_subnet.flow_ai_subnet_private_1a.id 
  route_table_id = aws_route_table.flow_ai_route_table_private.id
}

resource "aws_route_table_association" "flow_ai_route_association_private_1b" {
  subnet_id      = aws_subnet.flow_ai_subnet_private_1b.id 
  route_table_id = aws_route_table.flow_ai_route_table_private.id
}

resource "aws_route_table_association" "flow_ai_route_association_private_1c" {
  subnet_id      = aws_subnet.flow_ai_subnet_private_1c.id 
  route_table_id = aws_route_table.flow_ai_route_table_private.id
}
