provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "example" {
  name = var.repository_name
}
