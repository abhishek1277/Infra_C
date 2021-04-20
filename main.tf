provider "azurerm" {
  version = "~>2.46.0"
  skip_provider_registration = true
    features {}
    subscription_id="4ce31b1f-a57c-460a-8872-01fb7723db79"
    tenant_id="0c6fce42-0449-4574-bf9c-a261c5635a02"
    client_id="9dc23c4e-3ddf-494c-a0e1-5d5028082253"
    client_certificate_password="w5cE_22R72-mLyGS-Q86ZGII4I_UV6Jl.g"
}

resource "azurerm_resource_group" "xlabsrg" {
  name     = "r2"
  location = "East US"
}
