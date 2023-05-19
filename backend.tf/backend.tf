terraform {
  backend "s3" {
    bucket         = "myterraform05182023"
    key            = "some_environment/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "my-terraform-lock"
  }
}
