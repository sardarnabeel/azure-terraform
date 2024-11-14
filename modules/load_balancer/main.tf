# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                         = "${var.lb_name}-public-ip"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  allocation_method            = "Static"  # Static IP for persistent access
  sku                          = "Standard"  # Required SKU for public IP with Standard Load Balancers
}

# Load Balancer
resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"  # Required SKU for standard load balancer

  frontend_ip_configuration {
    name                      = "LoadBalancerFrontend"
    public_ip_address_id      = azurerm_public_ip.lb_public_ip.id  # Attach the public IP to the frontend
  }

  # Remove the backend_address_pool block here
  # The backend address pool is defined separately below
}

# Backend Address Pool (list of servers or VM IPs)
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id  # Link to the load balancer
  name            = "BackendPool"
}

# Health Probe Configuration
resource "azurerm_lb_probe" "lb_health_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "HealthProbe"
  protocol        = "Tcp"  # Can be "Http" or "Https" if needed
  port            = 80     # Health check port
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Load Balancing Rule
resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  disable_outbound_snat          = true  # Set to true to avoid conflict with outbound rule
#   backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

# Outbound Rule (Optional)
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
