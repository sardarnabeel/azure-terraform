


variable "ssh_public_key_path" {
  type = string
}
variable "Outbound-pub" {
  type = bool
}
variable "Outbound-pvt" {
  type = bool
}
variable "lb_name" {
  type = object({
    lb_name = string
  })
}

variable "mysqlnsg_name" {
  type = object({
    nsg_name              = string
    source_address_prefix = string
  })
  default = {
    nsg_name              = ""
    source_address_prefix = "*"
  }
}

variable "nat-var" {
  type = object({
    nat_gateway_name = string
  })
}

variable "rg-var" {
  type = object({
    location            = string
    resource_group_name = string
  })

}

variable "subnet-var-pub" {
  type = object({
    subnet_name      = string
    address_prefixes = list(string)
  })

}

variable "subnet-var-pvt" {
  type = object({
    subnet_name      = string
    address_prefixes = list(string)
  })

}

variable "mysqlvm-var" {
  type = object({
    vm_name = string
  })

}

variable "wordpressvm-var" {
  type = object({
    vm_name = string
  })

}

variable "vnet-var" {
  type = object({
    vnet_name     = string
    address_space = list(string)
  })

}

variable "wordpress-nsg-var" {
  type = object({
    nsg_name = string
  })
}
