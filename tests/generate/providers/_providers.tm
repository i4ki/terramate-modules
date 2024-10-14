// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

generate_hcl "_providers.tf" {
  lets {
    entries = global.modules.generate.terraform.providers.entries
    required_providers = { for v in let.entries : v.name => {
      source  = v.source
      version = v.version
    } }
  }
  content {
    terraform {
      tm_dynamic "required_providers" {
        attributes = let.required_providers
        for_each = tm_length(let.required_providers) > 0 ? [
          1,
          ] : [
        ]
      }
      tm_dynamic "provider" {
        attributes = p.value.config.attributes
        for_each   = let.entries
        iterator   = p
        labels = [
          p.value.name,
        ]
        content {
          tm_dynamic "assume_role" {
            attributes = b.value.attributes
            for_each = [for b in tm_try(p.value.config.blocks, [
            ]) : b if b.name == "assume_role"]
            iterator = b
          }
          tm_dynamic "any_other_block_name" {
            attributes = b.value.attributes
            for_each = [for b in tm_try(p.value.config.blocks, [
            ]) : b if b.name == "any_other_block_name"]
            iterator = b
          }
        }
      }
    }
  }
}
