resource "ovh_domain_zone_record" "opnsense_pub" {
  zone      = "formateur-devops.ovh"
  subdomain = "firewall"
  fieldtype = "A"
  ttl       = 3600
  target    = azurerm_public_ip.opnsense.ip_address
}

resource "azurerm_private_dns_a_record" "opnsense_int" {
  name                = "firewall"
  zone_name           = azurerm_private_dns_zone.correction_interne_azure.name
  resource_group_name = data.azurerm_resource_group.msp.name
  ttl                 = 300
  records             = [azurerm_network_interface.opnsense_trusted.private_ip_address]
}
