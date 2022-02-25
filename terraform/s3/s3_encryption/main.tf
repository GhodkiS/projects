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
region = "us-west-1"

}

resource "aws_kms_key" "mykey" {

  description             = "encryption key for S3"
  deletion_window_in_days = 10

}


resource "aws_s3_bucket" "s3" {

  bucket = "saurabh-29121991"

  server_side_encryption_configuration {

    rule {

      apply_server_side_encryption_by_default {

        kms_master_key_id = aws_kms_key.mykey.arn

        sse_algorithm = "aws:kms"


      }



    }



  }


}
