resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub"
  address_space       = ["192.168.1.0/24"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
}

resource "azurerm_subnet" "firewall_pub" {
  name                 = "Firewall-pub"
  resource_group_name  = data.azurerm_resource_group.msp.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["192.168.1.0/28"]
}
resource "azurerm_subnet" "firewall_priv" {
  name                 = "Firewall-priv"
  resource_group_name  = data.azurerm_resource_group.msp.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["192.168.1.16/28"]
}

resource "azurerm_subnet" "ressources" {
  name                 = "Ressources"
  resource_group_name  = data.azurerm_resource_group.msp.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["192.168.1.32/28"]
}


resource "azurerm_virtual_network" "spoke_devops_tools" {
  name                = "vnet-spoke-DevopsTools"
  address_space       = ["192.168.10.0/24"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
}
resource "azurerm_subnet" "spoke_devops_tools_docker_instances" {
  name                 = "DockerInstances"
  resource_group_name  = data.azurerm_resource_group.msp.name
  virtual_network_name = azurerm_virtual_network.spoke_devops_tools.name
  address_prefixes     = ["192.168.10.0/28"]
  delegation {
    name = "delegation-to-containers"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "spoke_devops_tools_bastion" {
  name                 = "bastion"
  resource_group_name  = data.azurerm_resource_group.msp.name
  virtual_network_name = azurerm_virtual_network.spoke_devops_tools.name
  address_prefixes     = ["192.168.10.16/28"]
}

resource "azurerm_virtual_network" "spoke_wordpress_prod" {
  name                = "vnet-spoke-wordpress-prod"
  address_space       = ["192.168.20.0/24"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
}
resource "azurerm_subnet" "spoke_wordpress_prod_mysql_flexible_servers" {
  name                 = "MysqlFlexiblesServers"
  resource_group_name  = data.azurerm_resource_group.msp.name
  virtual_network_name = azurerm_virtual_network.spoke_wordpress_prod.name
  address_prefixes     = ["192.168.20.0/28"]
  delegation {
    name = "delegation-to-flexible-servers"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
resource "azurerm_subnet" "spoke_wordpress_prod_docker_instances" {
  name                 = "DockerInstances"
  resource_group_name  = data.azurerm_resource_group.msp.name
  virtual_network_name = azurerm_virtual_network.spoke_wordpress_prod.name
  address_prefixes     = ["192.168.20.16/28"]
  delegation {
    name = "delegation-to-containers"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
