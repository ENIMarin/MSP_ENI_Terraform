# Peering du hub vers le spoke DevopsTools
resource "azurerm_virtual_network_peering" "hub_to_spoke_devops" {
  name                      = "hub-to-spoke-devops"
  resource_group_name       = data.azurerm_resource_group.msp.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_devops_tools.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

# Peering du spoke DevopsTools vers le hub
resource "azurerm_virtual_network_peering" "spoke_devops_to_hub" {
  name                      = "spoke-devops-to-hub"
  resource_group_name       = data.azurerm_resource_group.msp.name
  virtual_network_name      = azurerm_virtual_network.spoke_devops_tools.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

# Peering du hub vers le spoke Wordpress
resource "azurerm_virtual_network_peering" "hub_to_spoke_wordpress" {
  name                      = "hub-to-spoke-wordpress"
  resource_group_name       = data.azurerm_resource_group.msp.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_wordpress_prod.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

# Peering du spoke Wordpress vers le hub
resource "azurerm_virtual_network_peering" "spoke_wordpress_to_hub" {
  name                      = "spoke-wordpress-to-hub"
  resource_group_name       = data.azurerm_resource_group.msp.name
  virtual_network_name      = azurerm_virtual_network.spoke_wordpress_prod.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}
