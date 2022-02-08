terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"
      version = "~>3.27"

    }

  }
  required_version = ">0.14.9"

}

provider "aws" {

  profile = "default"
  region  = "us-west-1"

}

provider "aws" {

  alias   = "west2"
  region  = "us-west-2"
  profile = "default"
}


resource "aws_iam_role" "replication" {

  name               = "role-29121991"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}


resource "aws_iam_policy" "replication" {

  name   = "policy-29121991"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.source.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
         "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.source.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.destination.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {

  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn

}


resource "aws_s3_bucket" "destination" {
  bucket = "destination-29121991"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "source" {

  provider = aws.west2
  bucket   = "source-29121991"
  acl      = "private"
  versioning {

    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.replication.arn
    rules {
      id     = "foobar"
      status = "Enabled"

      filter {
        tags = {}
      }
      destination {
        bucket        = aws_s3_bucket.destination.arn
        storage_class = "STANDARD"

        replication_time {
          status  = "Enabled"
          minutes = 15
        }

        metrics {
          status  = "Enabled"
          minutes = 15
        }
      }
    }


  }
}

