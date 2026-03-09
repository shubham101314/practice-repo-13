variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "iam_instance_profile" {}
variable "tag_name" {}
variable "user_data" {
  description = "User data script for EC2"
  type        = string
}

