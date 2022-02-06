terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"
      version = "~>3.27"

    }
  }

  required_version = ">=0.14.9"

}


provider "aws" {

  profile = "default"
  region  = "us-west-1"

}


resource "aws_instance" "app_server" {

  ami           = "ami-009726b835c24a3aa"
  instance_type = "t2.micro"

  tags = {

    name = var.instance_name


  }

}
