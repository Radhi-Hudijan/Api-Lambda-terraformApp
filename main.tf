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

resource "aws_lambda_function" "qoute_generator_lambda" {
    function_name = "qoute-generator-lambda"
    s3_bucket = aws_s3_bucket.lambda_bucket.bucket
    s3_key = aws_s3_object.qoute_generator_lambda.key
    handler = "qoute-generator.lambda_handler"
    runtime = "python3.8"
    role = aws_iam_role.lambda_execution_role.arn
    timeout = 10
    memory_size = 128
}

resource "aws_cloudwatch_log_group" "qoute_generator_lambda" {
    name = "/aws/lambda/qoute-generator-lambda"
    retention_in_days = 14
  
}


#Api Geteway

resource "aws_apigatewayv2_api" "serverless_lambda" {
    name = "serverless_HTTP_GW"
    protocol_type = "HTTP"
}


resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.serverless_lambda.id
  name = "Dev_stage"
  auto_deploy = true
}

## integration and route for health check function

resource "aws_apigatewayv2_integration" "health" {
  description = "Health chcek function integration"
  api_id= aws_apigatewayv2_api.serverless_lambda.id
  integration_uri    = aws_lambda_function.health_check_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "health_route" {
    api_id = aws_apigatewayv2_api.serverless_lambda.id
    route_key = "GET /health"
    target = "integrations/${aws_apigatewayv2_integration.health.id}"
}


## integration and route for qoute generator function
resource "aws_apigatewayv2_integration" "qoute_generator" {
    description = "qoute generator integration"
    api_id = aws_apigatewayv2_api.serverless_lambda.id
    integration_uri = aws_lambda_function.qoute_generator_lambda.invoke_arn
    integration_type = "AWS_PROXY"
    integration_method = "POST"
}

resource "aws_apigatewayv2_route" "qoute_route" {
    api_id = aws_apigatewayv2_api.serverless_lambda.id
    route_key = "GET /qoute"
    target = "integrations/${aws_apigatewayv2_integration.qoute_generator.id}"
  
}


resource "aws_lambda_permission" "invoke_health_Lambda" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_check_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.serverless_lambda.execution_arn}/*/*/health"
  
}

resource "aws_lambda_permission" "invoke_qoute_Lambda" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.qoute_generator_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.serverless_lambda.execution_arn}/*/*/qoute"
  
}


#log group
resource "aws_cloudwatch_log_group" "api_gw" {
    name = "/aws/apigateway/${aws_apigatewayv2_api.serverless_lambda.name}"
    retention_in_days = 14
  
}