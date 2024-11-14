# Public IP
resource "azurerm_public_ip" "lb_public_ip" {
  name                         = "${var.lb.lb_name}-public-ip"
  location                     = var.lb.location
  resource_group_name          = var.lb.resource_group_name
  allocation_method            = "Static"
  sku                          = "Standard"
}

# Load Balancer
resource "azurerm_lb" "lb" {
  name                = var.lb.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                      = "LoadBalancerFrontend"
    public_ip_address_id      = azurerm_public_ip.lb_public_ip.id
  }

 
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id  # Link to thr lb
  name            = "BackendPool"
}

# Health Probe Configuration
resource "azurerm_lb_probe" "lb_health_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "HealthProbe"
  protocol        = "Tcp"
  port            = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Load Balancing Rule
resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  disable_outbound_snat          = true
}

# Outbound Rule
resource "azurerm_lb_outbound_rule" "lb_outbound_rule" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "OutboundRule"
  protocol        = "All"
frontend_ip_configuration {
    name = "LoadBalancerFrontend"
  }
  backend_address_pool_id       = azurerm_lb_backend_address_pool.lb_backend_pool.id
  allocated_outbound_ports      = 64
}

output "lb_public_ip" {
  value = azurerm_public_ip.lb_public_ip.ip_address
}
