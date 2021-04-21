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


  module "vnet" {
    source              = "Azure/vnet/azurerm"
    version             = "~> 1.0.0"
    location            = "West US 2"
    resource_group_name = "terraform-vm"
  }
