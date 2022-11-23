terraform {
  backend "remote" {
    organization = "organization-name"
    workspaces {
      name = "terraform-backend-handson"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}


provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "jenkins_server" {
  ami           = var.ami-name
  instance_type = var.instance-size
}
