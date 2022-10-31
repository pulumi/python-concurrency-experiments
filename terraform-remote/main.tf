terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-2"
}

// SQS 100 instances with a numbered name.
resource "aws_sqs_queue" "sqs-queue" {
  name = "queue-${count.index}"
  count = 100
  tags = {
    owner = "robbie-mckinstry"
    anyone-can-delete-me = "true"
    python-concurrency-experiment = "true"
  }
}


// SNS 100 topics with a numbered name.
resource "aws_sns_topic" "sns-topic" {
  name = "topic-${count.index}"
  count = 100
  tags = {
    owner = "robbie-mckinstry"
    anyone-can-delete-me = "true"
    python-concurrency-experiment = "true"
  }
}