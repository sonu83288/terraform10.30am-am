terraform {
  backend "s3" {
    bucket = "terraform-bucket-state-file-storage"
    key = "terraform.tfstate"
    use_lockfile =true
    region = "us-west-2"
  }
}