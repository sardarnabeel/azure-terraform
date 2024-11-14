variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "public_subnet_name" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

variable "public_subnet_prefix" {
  type = list(string)
}

variable "private_subnet_prefix" {
  type = list(string)
}

variable "nat_gateway_name" {
  type = string
}

variable "lb_name" {
  type = string
}
variable "ssh_public_key_path" {
  type = string
}
variable "mysqlnsg_name" {
  type = string
}
variable "wordpressnsg_name" {
  type = string
}
