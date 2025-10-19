# Create S3 bucket for Terraform state
aws s3api create-bucket \
  --bucket flow-ai-terraform-state-bucket \
  --region sa-east-1 \
  --create-bucket-configuration LocationConstraint=sa-east-1

# Enable bucket versioning
aws s3api put-bucket-versioning \
  --bucket flow-ai-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Enable server-side encryption (AES-256)
aws s3api put-bucket-encryption \
  --bucket flow-ai-terraform-state-bucket \
  --server-side-encryption-configuration file://encryption.json

# Set lifecycle policy to delete old versions after 90 days
aws s3api put-bucket-lifecycle-configuration \
  --bucket flow-ai-terraform-state-bucket \
  --region sa-east-1 \
  --lifecycle-configuration file://lifecycle.json

# Create the OIDC Provider for GitHub Actions
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com                      

# Create the OIDC Role for GitHub Actions
aws iam create-role \
  --role-name flow-ai-role-github-actions \
  --assume-role-policy-document file://trust-policy.json \
  --description "OIDC role for GitHub Actions Terraform deployments"

# Create the Policy for Terraform Deployments
aws iam create-policy \
  --policy-name flow-ai-terraform-deploy-policy \
  --policy-document file://terraform-deploy-policy.json

# Attach the Policy to the OIDC Role
aws iam attach-role-policy \
  --role-name flow-ai-role-github-actions \
  --policy-arn arn:aws:iam::***:policy/flow-ai-terraform-deploy-policy