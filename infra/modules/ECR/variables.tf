variable "repo_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "my-app-repo"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "availability_zones" {
  type    = list(string)
  default = []
}
outputs.tf (VPC Module)
hcl
Copy code
# modules/vpc/outputs.tf

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}
Step 5: Create the Main Infrastructure Configuration
In the root directory, create the main Terraform configuration files.
main.tf
hcl
Copy code
# main.tf

module "vpc" {
  source = "./modules/vpc"
}

# Security Group
resource "aws_security_group" "web" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances
resource "aws_instance" "web" {
  ami           = "ami-0c1a7f89451184c8b"
  instance_type = "t2.micro"
  subnet_id     = element(module.vpc.public_subnets, 0)
  security_groups = [aws_security_group.web.name]

  tags = {
    Name = "Web Server"
  }
}
