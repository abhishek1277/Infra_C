provider "azurerm" {
  version = "~>2.46.0"
    features {}

}

resource "azurerm_resource_group" "xlabsrg" {
  name     = "r2"
  location = "East US"
}
