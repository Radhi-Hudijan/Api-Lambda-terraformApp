terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

    required_version = ">= 0.14.9"
}

# Creating a new S3 bucket

resource "aws_s3_bucket" "lambda_bucket" {
    bucket = "lambda-bucket-123456789"  
}

# Lambda function

#health check function

# data "achive_file" "health_check_lambda" {
#     type = "zip"
#     source = "${path.module}/lambda/health_check.py"
#     output_path = "${path.module}/lambda/health_check.zip"
  
# }

# resource "aws_s3_bucket" "lambda_bucket" {
#   bucket = "lambda-bucket-123456789"
#   key = "lambda/health_check.zip"
#   source = data.achive_file.health_check_lambda.output_path  
# }
