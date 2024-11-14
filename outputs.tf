output "vnet_id" {
  value = module.vnet.vnet_id
}

output "public_subnet_id" {
  value = module.public_subnet.subnet_id
}

output "private_subnet_id" {
  value = module.private_subnet.subnet_id
}

output "nat_gateway_id" {
  value = module.nat_gateway.nat_gateway_id
}
