terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.9.0"
    }
    aap = {
      source  = "ansible/aap"
      version = ">= 1.1.2"
    }
  }
}
