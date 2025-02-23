terraform {
  required_version = "= 1.10.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }

  # tfstate file
  backend "s3" {
    bucket  = "tsar-terraform-state"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}
