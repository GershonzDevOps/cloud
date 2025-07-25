terraform {
  backend "s3" {
    bucket = "set-bucket25"
    key    = "terraform/cloud/ecr.tfstate"
    region = "us-east-1"
  }
}
