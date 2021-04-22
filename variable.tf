variable "resource_group_name" {
    type        = string
    description = "RG name in Azure"
    default ="My_Terraform_RG"
}

variable "resource_group_location" {
    type        = string
    description = "RG location in Azure"
    default ="West Europe"
}

variable "app_service_plan_name" {
    type        = string
    description = "App Service Plan name in Azure"
    default ="my-appserviceplan"
}

variable "app_service_name" {
    type        = string
    description = "App Service name in Azure"
    default = "terraform-demo-0099"
}
