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


 
resource "azurerm_resource_group" "example" {
  name     = "my-resources"
  location = "West Europe"
}
resource "azurerm_virtual_network" "main" {
  name                = "network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
module "subnet" {
  source              = "./modules/subnet"
 
}
