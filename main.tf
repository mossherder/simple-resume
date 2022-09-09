# azure region
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "southcentralus"
}

variable "client_app_name" {
  type    = string
  default = "client-simple-resume"
}

variable "client_image_name" {
  type    = string
  default = "client-simple-resume-image"
}

terraform {
  required_version = ">= 0.12"
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

# Create a Resource Group
data "azurerm_resource_group" "main-rg" {
  name = "Simple-Resume-App"
}

#
# CLIENT
#

# Create the App Service Plan
resource "azurerm_app_service_plan" "client-plan" {
  name                = "${var.client_app_name}-plan"
  location            = data.azurerm_resource_group.main-rg.location
  resource_group_name = data.azurerm_resource_group.main-rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = {
    description = "client app service plan"
  }
}

# Create the App Service
resource "azurerm_app_service" "app-service" {
  name                = "${var.client_app_name}-app"
  location            = data.azurerm_resource_group.main-rg.location
  resource_group_name = data.azurerm_resource_group.main-rg.name
  app_service_plan_id = azurerm_app_service_plan.client-plan.id
  https_only          = true

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.name}.azurecr.io/${var.client_image_name}:latest"
    always_on        = true
  }

  app_settings = {
    DOCKER_ENABLE_CI                = true
    DOCKER_REGISTRY_SERVER_URL      = "https://${azurerm_container_registry.acr.name}.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME = "${azurerm_container_registry.acr.admin_username}"
    DOCKER_REGISTRY_SERVER_PASSWORD = "${azurerm_container_registry.acr.admin_password}"
    WEBSITES_PORT                   = 8080
  }

  tags = {
    description = "client app service"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "simpleresumeregistryacr"
  resource_group_name = data.azurerm_resource_group.main-rg.name
  location            = data.azurerm_resource_group.main-rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_storage_account" "st" {
  name                     = "simpleresumeraccount"
  resource_group_name      = data.azurerm_resource_group.main-rg.name
  location                 = data.azurerm_resource_group.main-rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
