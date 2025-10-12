# Look up the latest Amazon Linux 2023 AMI with kernel 6.12 (x86_64)
data "aws_ssm_parameter" "al2023_kernel_612_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.12-x86_64"
}

# Command to create a pub key: ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_aws
resource "aws_key_pair" "deployer" {
  key_name   = "AWS-St"
  public_key = file("~/.ssh/id_rsa_aws.pub")
}

resource "aws_instance" "flow_ai_instance" {
  ami           = data.aws_ssm_parameter.al2023_kernel_612_ami.value
  instance_type = "t3.small" 
  key_name      = aws_key_pair.deployer.key_name
  
  subnet_id     = aws_subnet.flow_ai_subnet_public.id
  vpc_security_group_ids = [aws_security_group.flow_ai_sg.id]
  
  tags = {
    Name = "flow-ai-inv-ec2"
    Tag  = "flow-ai-inv"
  }

  # The user data script to run on first boot
  user_data = <<-EOF
    #!/bin/bash
    # Update system packages
    echo "Starting user data script"
    dnf -y upgrade --refresh

    # Check if Git is installed
    if ! command -v git &> /dev/null; then
        echo "Git not found. Installing Git..."
        dnf install git -y
    else
        echo "Git is already installed."
    fi

    # Check if Docker is installed (Docker is a standard package on AL2023, not an 'extra')
    if ! command -v docker &> /dev/null; then
        echo "Docker not found. Installing Docker..."
        # The 'amazon-linux-extras install docker -y' command is for Amazon Linux 2.
        # For Amazon Linux 2023, you install Docker directly with dnf.
        dnf install docker -y
        systemctl start docker
        systemctl enable docker
        # Add the current 'ec2-user' to the 'docker' group
        usermod -aG docker ec2-user
        echo "Docker installed and configured."
    else
        echo "Docker is already installed."
    fi

    # Check if Docker Compose is installed
    # In newer Docker installations (like the one in AL2023), 
    # 'docker-compose' is often installed as a 'docker compose' plugin.
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        echo "Docker Compose not found. Installing the latest version of Docker Compose..."
        # Using the standard installation method for the standalone docker-compose binary for broad compatibility
        DOCKER_CONFIG=/usr/local/lib/docker
        mkdir -p $DOCKER_CONFIG/cli-plugins
        curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        # Check installation path and symlink for compatibility
        if [ ! -f /usr/local/bin/docker-compose ]; then
            ln -s /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
        fi
        docker-compose version || docker compose version
    else
        echo "Docker Compose is already installed or 'docker compose' plugin is available."
    fi

    echo "Setup complete. Git, Docker and Docker Compose are ready to use."
    EOF
  # End user_data

}
