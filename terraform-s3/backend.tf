terraform {
  backend "s3" {
    bucket = "mckinstry-experiment-tf"
    key    = "terraformstate"
    region = "us-east-2"
  }  
}
