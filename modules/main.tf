resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "my-resources"
  virtual_network_name = "network"
  address_prefixes     = ["10.0.2.0/24"]
}
