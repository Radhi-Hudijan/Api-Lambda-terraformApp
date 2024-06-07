
#output values

output "lambda_bucket_name" {
  description = "value of the lambda bucket"
  value = aws_s3_bucket.lambda_bucket.bucket
  
}