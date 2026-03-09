output "vpc_cidr" {
  value = data.aws_vpc.existing.cidr_block
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}
output "ec2_instance_id" {
  value = module.ec2.instance_id
}
output "debug_files" {
  value = fileset(path.root, "**")
}
output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}
