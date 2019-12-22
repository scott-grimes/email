terraform {
  backend "s3" {
    bucket         = "u826281709174-correcthorsebatterystaple"
    encrypt        = true
    key            = "terraform"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}
