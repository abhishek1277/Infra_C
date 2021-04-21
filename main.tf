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


  module "windowsservers" {
    source              = "Azure/vm/azurerm"
    location            = "West US 2"
    vm_hostname         = "mywinvm" // line can be removed if only one VM module per resource group
    admin_password      = "ComplxP@ssw0rd!"
    vm_os_simple        = "WindowsServer"
    public_ip_dns       = ["winsimplevmips"] // change to a unique name per datacenter region
    vnet_subnet_id      = "${module.vnet.vnet_subnets[0]}"
  }

  module "vnet" {
    source              = "Azure/vnet/azurerm"
    version             = "~> 1.0.0"
    location            = "West US 2"
    resource_group_name = "terraform-vm"
  }
