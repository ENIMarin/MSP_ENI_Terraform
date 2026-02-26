# NSG for VNET spoke-devops-tools
resource "azurerm_network_security_group" "spoke_devops_tools" {
  name                = "nsg-spoke-devops-tools"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name

  security_rule {
    name                       = "AllowAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
}

# NSG for VNET spoke-wordpress-prod
resource "azurerm_network_security_group" "spoke_wordpress_prod" {
  name                = "nsg-spoke-wordpress-prod"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name

  security_rule {
    name                       = "AllowAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
}


resource "azurerm_subnet_network_security_group_association" "spoke_devops_tools_docker_instances" {
  subnet_id                 = azurerm_subnet.spoke_devops_tools_docker_instances.id
  network_security_group_id = azurerm_network_security_group.spoke_devops_tools.id
}
resource "azurerm_subnet_network_security_group_association" "spoke_devops_tools_bastion" {
  subnet_id                 = azurerm_subnet.spoke_devops_tools_bastion.id
  network_security_group_id = azurerm_network_security_group.spoke_devops_tools.id
}


resource "azurerm_subnet_network_security_group_association" "spoke_wordpress_prod_docker_instances" {
  subnet_id                 = azurerm_subnet.spoke_wordpress_prod_docker_instances.id
  network_security_group_id = azurerm_network_security_group.spoke_wordpress_prod.id
}
resource "azurerm_subnet_network_security_group_association" "spoke_wordpress_prod_mysql_flexible_servers" {
  subnet_id                 = azurerm_subnet.spoke_wordpress_prod_mysql_flexible_servers.id
  network_security_group_id = azurerm_network_security_group.spoke_wordpress_prod.id
}
