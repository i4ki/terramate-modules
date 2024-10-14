# Terramate Modules

## Install

Clone this repo into the `/modules` folder of your Terramate project.

```bash
git clone git@github.com:i4ki/terramate-modules.git ./modules/terramate-modules
```

Add a `.tmskip` file into the `modules/terramate-modules/tests` directory.
This is needed because this project comes with test stacks, otherwise they will
show up in your `terramate list` results.

```bash
touch ./modules/terramate-modules/tests/.tmskip
```

and then import the specific module and configure it accordingly to its documentation.

See usage examples below:

## Generate configurable variable blocks

Sometimes you have a highly configurable setup and you would like to generate
variable blocks dynamically, depending on if some flags are enabled or not.

```hcl
import {
  source = "/modules/terraform-modules/generate/terraform/variables/variables.tm"
}

globals "modules" "generate" "terraform" "variables" {
  entries = [
    {
      # only declaring name is enough.
      name = "empty_var"
    },
    # basic string variable
    {
      name      = "my_var"
      type      = "string"
      default   = "hello"
      sensitive = false
    },
    
    # line below only generate if feature abc is defined.
    tm_try(global.feature_abc.variable, null)
  ]
}
```

which generates:
```hcl
// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

variable "empty_var" {
}
variable "my_var" {
  default   = "hello"
  sensitive = false
  type      = string
}
```

## Generate the providers blocks

```hcl
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
```

This generates:

```hcl
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
```
