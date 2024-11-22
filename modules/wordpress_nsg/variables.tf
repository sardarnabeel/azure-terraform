

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "source_address_prefix" {
  type    = string
  default = "*"
}
variable "wordpress-nsg-var" {}