resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = local.tags
}

resource "random_password" "this" {
  length = 30
}

resource "azurerm_virtual_network" "this" {
  name     = "${var.prefix}-vnet"
  location = var.location

  address_space       = [var.vnet_address_space]
  resource_group_name = azurerm_resource_group.this.name

  tags = local.tags
}

resource "azurerm_subnet" "this" {
  name = "app-proxy"

  address_prefixes     = [var.subnet_address_space]
  resource_group_name  = azurerm_virtual_network.this.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
}

resource "azurerm_network_interface" "this" {
  name                          = "${var.prefix}-nic"
  location                      = var.location
  resource_group_name           = azurerm_virtual_network.this.resource_group_name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  name                  = "${var.prefix}-vm"
  admin_username        = var.prefix
  admin_password        = random_password.this.result
  location              = var.location
  network_interface_ids = [azurerm_network_interface.this.id]
  resource_group_name   = azurerm_subnet.this.resource_group_name
  size                  = var.size

  patch_mode = "AutomaticByPlatform"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition-core"
    version   = "latest"
  }

  tags = local.tags
}

output "vm_password" {
  value     = random_password.this.result
  sensitive = true
}
