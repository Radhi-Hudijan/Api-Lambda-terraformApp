
#output values

output "lambda_bucket_name" {
  description = "value of the lambda bucket"
  value = aws_s3_bucket.lambda_bucket.bucket
  
}

output "lambda_function_name" {
  description = "value of the lambda function"
  value = aws_lambda_function.health_check_lambda.function_name
}

