variable "repo_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "my-app-repo"
}
variable "machine_count" {
  description = "Number of machines to create"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = element(var.subnet_ids, count.index % length(var.subnet_ids))
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name        = "${var.environment}-machine-${count.index + 1}"
    Environment = var.environment
  }
variable "ami_id" {
  description = "AMI ID for the instances"


