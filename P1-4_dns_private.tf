resource "azurerm_private_dns_zone" "correction_interne_azure" {
  name                = "correction.interne.azure"
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
}

# Liaison réseau virtuel pour ateliermb.interne.azure. La fonction element permet de sélectionner l'élément adéquate en fonction de l'index du count. ça évite de faire 3 ressources...
resource "azurerm_private_dns_zone_virtual_network_link" "correction_interne_azure_links" {
  count                 = 3
  resource_group_name   = data.azurerm_resource_group.msp.name
  name                  = "ateliermb-interne-link-${count.index + 1}"
  private_dns_zone_name = azurerm_private_dns_zone.correction_interne_azure.name
  virtual_network_id = element(
    [
      azurerm_virtual_network.hub.id,
      azurerm_virtual_network.spoke_devops_tools.id,
      azurerm_virtual_network.spoke_wordpress_prod.id
    ],
    count.index
  )
  registration_enabled = true
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
}
