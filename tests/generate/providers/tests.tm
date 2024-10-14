# Test providers block generation

import {
  source = "/generate/terraform/providers/providers.tm"
}

globals "modules" "generate" "terraform" "providers" {
  entries = [
    {
      name    = "aws"
      source  = "hashicorp/aws"
      version = "~> 5.0"
      config = {
        attributes = {
          region = "us-east-1"
        }

        blocks = [
          {
            name = "assume_role"
            attributes = {
              role_arn     = "arn:aws:iam::123456789012:role/ROLE_NAME"
              session_name = "SESSION_NAME"
              external_id  = "EXTERNAL_ID"
            }
          },
          {
            name = "assume_role"
            attributes = {
              role_arn = "arn:aws:iam::123456789012:role/FINAL_ROLE_NAME"
            }
          },
          {
            name = "any_other_block_name"
            attributes = {
              whatever = 1
            }
          },
        ]
      }
    },
    {
      name    = "google"
      source  = "hashicorp/google"
      version = "~> 6.6.0",
      config = {
        attributes = {
          project = "my-project-id"
          region  = "us-central1"
        }
      }
    }
  ]
}
