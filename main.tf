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
  name     = "r3"
  location = "East US"
}
