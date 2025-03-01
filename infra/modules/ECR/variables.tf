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

