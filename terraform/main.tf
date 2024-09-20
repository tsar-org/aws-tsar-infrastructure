terraform {
  required_version = "= 1.9.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.68.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "= 1.1.1"
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
