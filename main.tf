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


resource "aws_lambda_function" "health_check_lambda" {
    function_name = "health-check-lambda"
    s3_bucket = aws_s3_bucket.lambda_bucket.bucket
    s3_key = aws_s3_object.health_check_lambda.key
    handler = "health-check.lambda_handler"
    runtime = "python3.8"
    role = aws_iam_role.lambda_execution_role.arn
    timeout = 10
    memory_size = 128
}

resource "aws_cloudwatch_log_group" "health_check_lambda" {
    name = "/aws/lambda/health-check-lambda"
    retention_in_days = 14
  
}

resource "aws_iam_role" "lambda_execution_role" {
    name = "lambda-role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    role = aws_iam_role.lambda_execution_role.name
  
}


#qoute of the day function

data "archive_file" "qoute_generator_lambda" {
    type = "zip"
    source_file = "${path.module}/lambdaFunctions/qoute-generator.py"
    output_path = "${path.module}/lambdaFunctions/qoute-generator.zip"
  
}

resource "aws_s3_object" "qoute_generator_lambda" {
    bucket = aws_s3_bucket.lambda_bucket.bucket
    key = "qoute-generator.zip"
    source = data.archive_file.qoute_generator_lambda.output_path
}










