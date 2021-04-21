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
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}
