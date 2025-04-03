terraform {
  required_version = "= 1.10.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "= 1.1.1"
    }
  }
}
