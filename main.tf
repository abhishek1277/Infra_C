provider "azurerm" {
  features {}
}

//Create an azure Resource Group
resource "azurerm_resource_group" "xlabsrg" {
  name     = "r1"
  location = "East US"
}

