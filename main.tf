data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "Prod112"
    workspaces = {
      name = "Infra_C"
    }
  }
}

provider "azurerm" {
  version = "~>2.46.0"
    features {}
  }
resource "azurerm_resource_group" "xlabsrg" {
  name     = "${var.resourcegroup}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "xlabsvn" {
    name = "${var.virtnetname}"
    address_space = ["${var.vnet_addr_space}"]
    location = "${azurerm_resource_group.xlabsrg.location}"
    resource_group_name = "${azurerm_resource_group.xlabsrg.name}"
}

resource "azurerm_subnet" "xlabssnet" {
    name = "${var.subnetname}"
    resource_group_name = "${azurerm_resource_group.xlabsrg.name}"
    virtual_network_name = "${azurerm_virtual_network.xlabsvn.name}"
    address_prefix = "${var.subnet_addr_prefix}"
}


resource "azurerm_public_ip" "xlabsip" {
    name                         = "${var.publicip}"
    location                     = "${azurerm_resource_group.xlabsrg.location}"
    resource_group_name          = "${azurerm_resource_group.xlabsrg.name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "stage"
    }
}

resource "azurerm_network_security_group" "xlabssecgrp" {
    name                = "${var.sqlsecgrp}"
    location            = "${azurerm_resource_group.xlabsrg.location}"
    resource_group_name = "${azurerm_resource_group.xlabsrg.name}"
    
    security_rule {
        name                       = "${var.sqlserver_port1_name}"
        priority                   = "1001"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "${var.sql_port_number1}"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "${var.sqlserver_port2_name}"
        priority                   = "1002"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "${var.sql_port_number2}"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}



resource "azurerm_network_interface" "xlabsnic" {
    name = "${var.sqlnicnew}"
    location = "${azurerm_resource_group.xlabsrg.location}"
    resource_group_name = "${azurerm_resource_group.xlabsrg.name}"

   

    ip_configuration {
        name = "${var.sqlvmipnew-configuration}"
        subnet_id = "${azurerm_subnet.xlabssnet.id}"
        private_ip_address_allocation = "dynamic"
      public_ip_address_id = "${azurerm_public_ip.xlabsip.id}"
    }
}
resource "azurerm_virtual_machine" "xlabsvm" {
    name = "${var.sqlvmname}"
    location = "${azurerm_resource_group.xlabsrg.location}"
    resource_group_name = "${azurerm_resource_group.xlabsrg.name}"
    network_interface_ids = ["${azurerm_network_interface.xlabsnic.id}"]
    vm_size = "${var.vm_size}"


    storage_image_reference {
        offer     = "${var.i_offer}" 
        publisher = "${var.i_publisher}"
        sku       = "${var.i_sku}" 
        version   = "${var.i_version}"
        }

    boot_diagnostics {
        enabled     = true
        storage_uri = "${var.boot_url}"
        }

    storage_os_disk {
        name              = "${var.os_disk}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
            }

    storage_data_disk {
        name = "${var.add_disk_name}"
        managed_disk_type = "Standard_LRS"
        create_option = "Empty"
        lun = 0
        disk_size_gb = "${var.add_disk_size}"
        }

    os_profile {
        computer_name  = "${var.computer_name}"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }

    os_profile_windows_config {  
    //enable_automatic_upgrades = true  
    provision_vm_agent         = true  
  }  
}


