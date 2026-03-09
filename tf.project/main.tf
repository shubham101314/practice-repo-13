# Existing VPC
data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Existing Subnet
data "aws_subnet" "existing" {
  id = var.subnet_id
}

# Existing Security Group
data "aws_security_group" "existing" {
  id = var.security_group_id
}
module "ec2" {
  source = "./modules/ec2"

  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  subnet_id            = data.aws_subnet.existing.id
  security_group_id    = data.aws_security_group.existing.id
  iam_instance_profile = var.iam_instance_profile
  tag_name             = var.tag_name
  user_data = file("${path.root}/modules/ec2/uds.sh")

}
resource "aws_ecr_repository" "app_repo" {
  name = "my-app-repository"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}
