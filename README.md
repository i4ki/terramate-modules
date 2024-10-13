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
```
// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

variable "empty_var" {
}
variable "my_var" {
  default   = "hello"
  sensitive = false
  type      = string
}
```

