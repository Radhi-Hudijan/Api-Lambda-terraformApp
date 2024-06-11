terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.38.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.2"
    }
  }

    required_version = "~> 1.2"
}

# Creating a new S3 bucket
resource "aws_s3_bucket" "lambda_bucket" {
    bucket = "lambda-bucket-123456789"  
}

