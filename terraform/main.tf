terraform {
  required_version = "= 1.11.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.96.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
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
