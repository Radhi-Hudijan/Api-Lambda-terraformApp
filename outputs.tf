
#output values

output "lambda_bucket_name" {
  description = "value of the lambda bucket"
  value = aws_s3_bucket.lambda_bucket.bucket
  
}

output "lambda_function_name" {
  description = "value of the lambda function"
  value = aws_lambda_function.health_check_lambda.function_name
}


output "base_api_url" {
  description = "value of the base api url"
  value = aws_apigatewayv2_api.serverless_lambda.api_endpoint
}

output "stage_base_url" {
  description = "value of the stage base url"
  value = aws_apigatewayv2_stage.lambda.invoke_url
  
}