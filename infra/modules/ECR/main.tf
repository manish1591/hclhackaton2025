module "machine" {
  source            = "./modules/machine"
  machine_count     = var.machine_count
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  environment       = var.environment
  key_name          = var.key_name
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  security_group_ids = var.security_group_ids
}
resource "aws_ecr_repository" "app_repo" {
  name = var.repo_name
}
