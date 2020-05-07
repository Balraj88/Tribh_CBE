resource "azurerm_resource_group" "VirtualMain" {
  name          = "VirtualNetwork"
  address_space = ["10.1.2.0/24"]
  location      = "Coimbatore"

  Tags  {
      Owner = "Balraj"
  }
  }
}
variable "prefix" {
  default = "VirtualNetwork"
}


resource "azurerm_virtual_network" "Main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.VirtualMain.location}"
  resource_group_name = "${azurerm_resource_group.VirtualMain.name}"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.VirtualMain.name}"
  virtual_network_name = "${azurerm_virtual_network.VirtualMain.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "Main" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.VirtualMain.location}"
  resource_group_name = "${azurerm_resource_group.mainVirtualMain.name}"
  Networ_interface_ids= 

  ip_configuration {
    name                          = "InternalTest"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = "${azurerm_resource_group.VirtualMain.location}"
  resource_group_name   = "${azurerm_resource_group.VirtualMain.name}"
  network_interface_ids = ["${azurerm_network_interface.VirtualMain.id}"]
  vm_size               = "Standard_DS1_v2"

  resource "azurerm_virtual_machine" "Main" {
  name                  = "${var.prefix}-vm"
  location              = "${azurerm_resource_group.VirtualMain.location}"
  resource_group_name   = "${azurerm_resource_group.VirtualMain.name}"
  network_interface_ids = ["${azurerm_network_interface.VirtualMain.id}"]
  vm_size               = "Standard_DS1_v2"

  

  # Uncomment this line to delete the OS disk automatically when deleting the VM
 delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
 delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_ZRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "admin"
    admin_password = "admin@123*"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    Owner = "Balraj"
  }
}
}