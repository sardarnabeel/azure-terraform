variable "lb_name" {
  description = "The name of the Load Balancer"
  type        = string
}

variable "location" {
  description = "The location/region of the Load Balancer"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
}

# variable "subnet_id" {
#   description = "The subnet ID where the load balancer will be deployed"
#   type        = string
# }
