terraform {
  backend "s3" {
    bucket = "terraform-backend-mv"
    key    = "lambda"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "app" {
  backend = "s3"
  config = {
    bucket = "terraform-backend-mv"
    key    = "app"
    region = "us-east-1"
  }
}