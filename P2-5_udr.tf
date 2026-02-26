
resource "azurerm_route_table" "alldefaultrouting" {
  name                = "alldefaultrouting"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
}

resource "azurerm_route" "to_firewall" {
  name                   = "all-to-nva"
  resource_group_name    = data.azurerm_resource_group.msp.name
  route_table_name       = azurerm_route_table.alldefaultrouting.name
  address_prefix         = "0.0.0.0/0" # Tout le trafic vers Internet
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.opnsense_trusted.private_ip_address
}

resource "azurerm_subnet_route_table_association" "alldefaultrouting_spoke_devops_tools_bastion" {
  subnet_id      = azurerm_subnet.spoke_devops_tools_bastion.id
  route_table_id = azurerm_route_table.alldefaultrouting.id
}

resource "azurerm_subnet_route_table_association" "alldefaultrouting_spoke_devops_tools_docker_instances" {
  subnet_id      = azurerm_subnet.spoke_devops_tools_docker_instances.id
  route_table_id = azurerm_route_table.alldefaultrouting.id
}

resource "azurerm_subnet_route_table_association" "alldefaultrouting_spoke_wordpress_prod_docker_instances" {
  subnet_id      = azurerm_subnet.spoke_wordpress_prod_docker_instances.id
  route_table_id = azurerm_route_table.alldefaultrouting.id
}

resource "azurerm_subnet_route_table_association" "alldefaultrouting_spoke_wordpress_prod_mysql_flexible_servers" {
  subnet_id      = azurerm_subnet.spoke_wordpress_prod_mysql_flexible_servers.id
  route_table_id = azurerm_route_table.alldefaultrouting.id
}

