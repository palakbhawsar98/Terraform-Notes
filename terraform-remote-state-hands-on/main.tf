terraform {
  backend "remote" {
    organization = "palak-terraform-oragnization"
    workspaces {
      name = "terraform-remote-state"
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
  region  = "us-east-1"
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
}
