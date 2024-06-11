
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

output "health_lambda_invoke_arn" {
  description = "value of the lambda invoke arn"
  value = aws_lambda_function.health_check_lambda.invoke_arn
}

output "quote_lambda_invoke_arn" {
  description = "value of the lambda invoke arn"
  value = aws_lambda_function.qoute_generator_lambda.invoke_arn
}