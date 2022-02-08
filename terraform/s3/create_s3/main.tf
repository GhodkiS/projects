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

resource "aws_s3_bucket" "b" {

bucket =  "bucket-1125"
acl = "private"
tags = {

name = "my bucket"
env = "development"

}


}

resource aws_s3_bucket "web_b" {

bucket = "static-web-29121991"
acl = "private"
#policy = file("policy.json")
website {

index_document  = "index.html"
error_document = "error.html"
routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
}
tags = {

name = "web server"
env = "production"

}
} 
