data "azurerm_resource_group" "rg" {
  name = "myRg-terr"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
    name                ="tf-nsg"
    location            = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
    
} 

#allow ssh
resource "azurerm_network_security_rule" "ssh" {
    resource_group_name = data.azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     ="22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

}

#public ip
resource "azurerm_public_ip" "pip" {
    name                 = "tf-public-ip"
    location             = data.azurerm_resource_group.rg.location
    resource_group_name  = data.azurerm_resource_group.rg.name
    allocation_method    = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = "tf-nic"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

#associate nsg

resource "azurerm_network_interface_security_group_association" "assoc" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  size                  = "Standard_B1ms"
  admin_username        = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/Users/user/.ssh/id_rsa.pub")
  }

   os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}