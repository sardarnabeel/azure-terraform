variable "nsg_name" {
  type = string
}

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
