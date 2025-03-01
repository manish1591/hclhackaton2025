provider "aws" {
  region = "ap-south-1"
}
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}
resource "aws_ecr_repository" "app_repo" {
  name = var.repo_name
}
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
}

module "vpc" {
  source = "./modules/ECR"
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
