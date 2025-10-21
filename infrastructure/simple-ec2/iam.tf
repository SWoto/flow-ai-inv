# IAM role for EC2 instance
resource "aws_iam_role" "ec2_instance_role" {
  name = "flow-ai-simple-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# IAM policy for S3 access (for terraform state and other S3 operations)
resource "aws_iam_policy" "s3_policy" {
  name        = "flow-ai-simple-ec2-s3-policy"
  description = "Allows the EC2 instance to access S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::flow-ai-terraform-state-bucket",
          "arn:aws:s3:::flow-ai-terraform-state-bucket/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:ListAllMyBuckets"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach S3 policy to the role
resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# Attach SSM policy for session manager access
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "flow-ai-simple-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}
