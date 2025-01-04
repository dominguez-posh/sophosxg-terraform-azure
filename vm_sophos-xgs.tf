resource "random_password" "SfosPW" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_virtual_machine" "sfosvm" {
  zones                        = [1]
  count                        = 1
  name                         = "vm-sophosxgs"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.sfoswanport1.id, azurerm_network_interface.sfoslanport1.id]
  primary_network_interface_id = azurerm_network_interface.sfoswanport1.id
  vm_size                      = var.size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "sophos"
    offer     = "sophos-xg"
    sku       = var.license_type
    version   = "latest"
  }

  plan {
    name      = var.license_type
    publisher = "sophos"
    product   = "sophos-xg"
  }

  storage_os_disk {
    name              = "osdisk_sophosxgs"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "datadisk_sophosxgs"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    disk_size_gb      = "128"
    lun               = 0
  }

  os_profile {
    computer_name  = "vm-sophosxgs"
    admin_username = var.adminusername
    admin_password = random_password.SfosPW.result
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.sfosstorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = var.environment_tag
  }
}