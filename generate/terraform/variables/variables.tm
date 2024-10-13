# Generate the variables block.
#
# Example configuration:
globals "modules" "generate" "terraform" "variables" {
  entries = [
    # {name = "some_var_name", type = "list", default = ["test"]}
  ]
}

# Generate variable blocks based on a globals configuration.
generate_hcl "_variables.tf" {
  content {
    tm_dynamic "variable" {
      # Note: It's a feature that `null` entries can be present so it's easier to disable
      # entries. Eg.: entries = [tm_try(global.featA, null), tm_try(global.festB, null), ...]
      for_each = [for v in global.modules.generate.terraform.variables.entries : v if v != null]
      iterator = var
      labels   = [var.value.name]

      attributes = { for k, v in {
        default   = tm_try(var.value.default, null)
        type      = tm_try(tm_hcl_expression(var.value.type), null)
        sensitive = tm_try(var.value.sensitive, null)
        } : k => v if v != null
      }
    }
  }
}
