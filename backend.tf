terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket  = "ezekiel-components-tfstate"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}