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