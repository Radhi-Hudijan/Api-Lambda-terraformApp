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


# Lambda function

#health check function

data "archive_file" "health_check_lambda" {
    type = "zip"
    source_file = "${path.module}/lambdaFunctions/health-check.py"
    output_path = "${path.module}/lambdaFunctions/health-check.zip"
}

resource "aws_s3_object" "health_check_lambda" {
    bucket = aws_s3_bucket.lambda_bucket.bucket
    key = "health-check.zip"
    source = data.archive_file.health_check_lambda.output_path
}
