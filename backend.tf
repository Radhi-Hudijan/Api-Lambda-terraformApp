terraform {
    backend "s3" {
        bucket         = "lambda-api-backend223344"
        key            = "terraform.tfstate"
        region         = "eu-west-1"
    }
}