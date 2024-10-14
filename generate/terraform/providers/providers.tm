# Generate the required_providers and providers block.
#
# Example configuration:
globals "modules" "generate" "terraform" "providers" {
  entries = []
}

generate_hcl "_providers.tm" {
  lets {
    entries = tm_try(global.modules.generate.terraform.providers.entries, [])
  }
  content {
    generate_hcl "_providers.tf" {
      lets {
        entries            = tm_hcl_expression("global.modules.generate.terraform.providers.entries")
        required_providers = tm_hcl_expression("{ for v in let.entries : v.name => {source = v.source, version = v.version}}")
      }

      content {
        terraform {
          tm_dynamic "tm_dynamic" {
            labels = ["required_providers"]
            attributes = {
              for_each = tm_hcl_expression("tm_length(let.required_providers) > 0 ? [1] : []")
              attributes = tm_hcl_expression("let.required_providers")
            }
          }

          tm_dynamic "tm_dynamic" {
            labels = ["provider"]
            attributes = {
              for_each   = tm_hcl_expression("let.entries")
              iterator   = tm_hcl_expression("p")
              labels     = tm_hcl_expression("[p.value.name]")
              attributes = tm_hcl_expression("p.value.config.attributes")
            }

            content {
              content {
                # hacks until Terramate supports tm_dynamic.block attribute.
                tm_dynamic "tm_dynamic" {
                  for_each = tm_distinct(tm_flatten([for i, p in let.entries : [for b in tm_try(p.config.blocks, []) : b.name]]))
                  iterator = block
                  labels   = [block.value]
                  attributes = {
                    for_each   = tm_hcl_expression("[for b in tm_try(p.value.config.blocks, []) : b if b.name == \"${block.value}\"]")
                    iterator   = tm_hcl_expression("b")
                    attributes = tm_hcl_expression("b.value.attributes")
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

