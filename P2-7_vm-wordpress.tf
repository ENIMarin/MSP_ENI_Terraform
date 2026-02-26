resource "azurerm_subnet" "spoke_wordpress_prod_vm" {
  name                 = "vm"
  resource_group_name  = data.azurerm_resource_group.msp.name
  virtual_network_name = azurerm_virtual_network.spoke_wordpress_prod.name
  address_prefixes     = ["192.168.20.32/28"]
}

resource "azurerm_network_interface" "wordpress" {
  name                = "nic-wordpress"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
  ip_configuration {
    name                          = "nic-subnet-vm"
    subnet_id                     = azurerm_subnet.spoke_wordpress_prod_vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "wordpress" {
  name                = "vm-wordpress"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.msp.name
  tags = {
    user = data.azurerm_resource_group.msp.tags["user"]
  }
  size           = "Standard_B1ls"
  admin_username = "matthieu"

  network_interface_ids = [
    azurerm_network_interface.wordpress.id
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

resource "ovh_domain_zone_record" "wordpress" {
  zone      = "formateur-devops.ovh"
  subdomain = "wordpress"
  fieldtype = "A"
  ttl       = 3600
  target    = azurerm_public_ip.opnsense.ip_address
}


resource "azurerm_subnet_route_table_association" "alldefaultrouting_spoke_wordpress_prod_vm" {
  subnet_id      = azurerm_subnet.spoke_wordpress_prod_vm.id
  route_table_id = azurerm_route_table.alldefaultrouting.id
}
