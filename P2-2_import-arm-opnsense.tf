resource "azurerm_network_interface" "opnsense_trusted" {
  name                = "OPNsense-Trusted-NIC"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.firewall_priv.id
    private_ip_address_allocation = "Dynamic"
  }
  ip_forwarding_enabled = true
}
import {
  to = azurerm_network_interface.opnsense_trusted
  id = "/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-MBailleul2024_cours-adminazure-projet/providers/Microsoft.Network/networkInterfaces/OPNsense-Trusted-NIC"
}

resource "azurerm_network_interface" "opnsense_untrusted" {
  name                = "OPNsense-Untrusted-NIC"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.firewall_pub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.opnsense.id
  }
  ip_forwarding_enabled = true
}
import {
  to = azurerm_network_interface.opnsense_untrusted
  id = "/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-MBailleul2024_cours-adminazure-projet/providers/Microsoft.Network/networkInterfaces/OPNsense-Untrusted-NIC"
}



resource "azurerm_network_security_group" "opnsense" {
  name                = "OPNsense-NSG"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name

  security_rule {
    name                       = "In-Any"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Out-Any"
    priority                   = 4096
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

import {
  to = azurerm_network_security_group.opnsense
  id = "/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-MBailleul2024_cours-adminazure-projet/providers/Microsoft.Network/networkSecurityGroups/OPNsense-NSG"
}


resource "azurerm_network_interface_security_group_association" "opnsense_trusted" {
  network_interface_id      = azurerm_network_interface.opnsense_trusted.id
  network_security_group_id = azurerm_network_security_group.opnsense.id
}
import {
  to = azurerm_network_interface_security_group_association.opnsense_trusted
  id = "/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-MBailleul2024_cours-adminazure-projet/providers/Microsoft.Network/networkInterfaces/OPNsense-Trusted-NIC|/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-MBailleul2024_cours-adminazure-projet/providers/Microsoft.Network/networkSecurityGroups/OPNsense-NSG"
}
resource "azurerm_network_interface_security_group_association" "opnsense_untrusted" {
  network_interface_id      = azurerm_network_interface.opnsense_untrusted.id
  network_security_group_id = azurerm_network_security_group.opnsense.id
}
import {
  to = azurerm_network_interface_security_group_association.opnsense_untrusted
  id = "/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-MBailleul2024_cours-adminazure-projet/providers/Microsoft.Network/networkInterfaces/OPNsense-Untrusted-NIC|/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-MBailleul2024_cours-adminazure-projet/providers/Microsoft.Network/networkSecurityGroups/OPNsense-NSG"
}


resource "azurerm_public_ip" "opnsense" {
  name                = "OPNsense-PublicIP"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  allocation_method   = "Static"
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
}
import {
  to = azurerm_public_ip.opnsense
  id = "/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/rg-MBailleul2024_cours-adminazure-projet/providers/Microsoft.Network/publicIPAddresses/OPNsense-PublicIP"
}

resource "azurerm_linux_virtual_machine" "opnsense" {
  name                = "OPNSENSE"
  location            = var.location
  resource_group_name = upper(data.azurerm_resource_group.msp.name)
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
  network_interface_ids = [
    azurerm_network_interface.opnsense_untrusted.id,
    azurerm_network_interface.opnsense_trusted.id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 32
  }
  source_image_reference {
    publisher = "thefreebsdfoundation"
    sku       = "14_1-release-amd64-gen2-zfs"
    offer     = "freebsd-14_1"
    version   = "latest"
  }
  disable_password_authentication = false
  plan {
    name      = "14_1-release-amd64-gen2-zfs"
    product   = "freebsd-14_1"
    publisher = "thefreebsdfoundation"
  }
}
import {
  to = azurerm_linux_virtual_machine.opnsense
  id = "/subscriptions/ca5c57dd-3aab-4628-a78c-978830d03bbd/resourceGroups/RG-MBAILLEUL2024_COURS-ADMINAZURE-PROJET/providers/Microsoft.Compute/virtualMachines/OPNSENSE"
}

