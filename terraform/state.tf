terraform {
  backend "s3" {
    bucket = "terraform.dreddick.home2"
    key    = "aws-go/terraform.tfstate"
    region = "eu-west-1"
  }
}
