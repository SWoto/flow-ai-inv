# Simple EC2
This setup creates a free tier EC2 instance while ensuring the entire network path (VPC → Subnet → IGW → Route Table) is in place, and the instance's firewall (Security Group) is configured to allow both SSH (for remote management) and ICMP (for ping/reachability checks).

## Notes
- Create a ssh key pair with `ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_aws` and change the path in `ec2.tf` file.
- Change the path to your aws credentials file in the `config.tf`file.