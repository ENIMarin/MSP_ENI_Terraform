resource "azurerm_network_interface" "bastion" {
  name                = "nic-bastion"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
  ip_configuration {
    name                          = "nic-subnet-bastion"
    subnet_id                     = azurerm_subnet.spoke_devops_tools_bastion.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "bastion" {
  name                = "vm-bastion"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
  size           = "Standard_B1ls"
  admin_username = "matthieu"

  network_interface_ids = [
    azurerm_network_interface.bastion.id
  ]
  disable_password_authentication = true
  admin_ssh_key {
    username   = "matthieu"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }
  source_image_reference {
    publisher = "Canonical"
    sku       = "server"
    offer     = "ubuntu-24_04-lts"
    version   = "latest"
  }
}

resource "ovh_domain_zone_record" "bastion" {
  zone      = "formateur-devops.ovh"
  subdomain = "bastion"
  fieldtype = "A"
  ttl       = 3600
  target    = azurerm_public_ip.opnsense.ip_address
}
