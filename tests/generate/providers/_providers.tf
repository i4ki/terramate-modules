// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.6.0"
    }
  }
  provider "aws" {
    region = "us-east-1"
    assume_role {
      external_id  = "EXTERNAL_ID"
      role_arn     = "arn:aws:iam::123456789012:role/ROLE_NAME"
      session_name = "SESSION_NAME"
    }
    assume_role {
      role_arn = "arn:aws:iam::123456789012:role/FINAL_ROLE_NAME"
    }
    any_other_block_name {
      whatever = 1
    }
  }
  provider "google" {
    project = "my-project-id"
    region  = "us-central1"
  }
}
