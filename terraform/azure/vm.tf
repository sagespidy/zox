provider "azurerm" { }

resource "azurerm_resource_group" "zox" {
  name     = "zox"
  location = "West US 2"
}

resource "azurerm_virtual_network" "zox" {
  name                = "acctvn"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.zox.location}"
  resource_group_name = "${azurerm_resource_group.zox.name}"
}



resource "azurerm_network_interface" "zox" {
  name                = "acctni"
  location            = "${azurerm_resource_group.zox.location}"
  resource_group_name = "${azurerm_resource_group.zox.name}"

  ip_configuration {
    name                          = "zoxconfiguration1"

    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_managed_disk" "zox" {
  name                 = "datadisk_existing"
  location             = "${azurerm_resource_group.zox.location}"
  resource_group_name  = "${azurerm_resource_group.zox.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "100"
}

resource "azurerm_virtual_machine" "zox" {
  name                  = "acctvm"
  location              = "${azurerm_resource_group.zox.location}"
  resource_group_name   = "${azurerm_resource_group.zox.name}"
  network_interface_ids = ["${azurerm_network_interface.zox.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "lazox"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.zox.name}"
    managed_disk_id = "${azurerm_managed_disk.zox.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.zox.disk_size_gb}"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "zoxadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }
}
