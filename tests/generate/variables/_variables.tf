// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

variable "empty_var" {
}
variable "my_var" {
  default   = "hello"
  sensitive = false
  type      = string
}
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
