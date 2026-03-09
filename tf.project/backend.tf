terraform {
  backend "s3" {
    bucket       = "tf-pjkt-13"
    key          = "free-tier-project/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
