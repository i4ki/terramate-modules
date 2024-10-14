# Test basic string variables

import {
  source = "/generate/terraform/variables/variables.tm"
}

globals {
  testcases = [
    {
      # only declaring name is enough.
      config = {
        name = "empty_var"
      },
      expected = <<-EOF
        variable "empty_var" {
        }
      EOF
    },
    {
      # basic string variable
      config = {
        name      = "my_var"
        type      = "string"
        default   = "hello"
        sensitive = false
      },
      expected = <<-EOF
        variable "my_var" {
          default   = "hello"
          sensitive = false
          type      = string
        }
      EOF
    },
    {
      # basic object variable
      config = {
        name = "my_object"
        type = "object({number = number, str = string})"
        default = {
          number = 1
          str    = "terramate"
        }
        sensitive = true
      },
      expected = <<-EOF
        variable "my_object" {
          default = {
            number = 1
            str    = "terramate"
          }
          sensitive = true
          type = object({
            number = number
            str    = string
          })
        }
      EOF
    },
    {
      # null is ignored in the entries list.
      config   = null,
      expected = null,
    }
  ]
}

globals "modules" "generate" "terraform" "variables" {
  entries = [for k, v in global.testcases : v.config]
}

assert {
  assertion = tm_alltrue(
    [for v in global.testcases :
    v.expected == null ? true : tm_strcontains(tm_try(tm_file("_variables.tf"), ""), v.expected)]
  )
  message = "test failed"
}

