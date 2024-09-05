terraform {
  required_version = "= 1.9.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "~> 1.1.0"
    }
  }
}
