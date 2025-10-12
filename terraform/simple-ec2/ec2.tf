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

}
