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


 
resource "azurerm_resource_group" "main" {
  name     = "resources"
  location = "West Europe"
}

}
 module "vnet" {
    source              = "Azure/vnet/azurerm"
    location            = "WestEurope"
    resource_group_name = azurerm_resource_group.main.name
    address_space       = ["10.0.0.0/16"]
  }
