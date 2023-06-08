# Define the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "web-site" {
  name     = "sal-rg-website"
  location = "West Europe"
}

# Create an App Service Plan
resource "azurerm_app_service_plan" "web-sp" {
  name                = "sal-app-web-sp"
  location            = azurerm_resource_group.web-site.location
  resource_group_name = azurerm_resource_group.web-site.name
  sku {
    tier = "Basic"
    size = "B1"
  }
}

# Create a Web App
resource "azurerm_app_service" "web-ap" {
  name                = "my-web-app"
  location            = azurerm_resource_group.web-site.location
  resource_group_name = azurerm_resource_group.web-site.name
  app_service_plan_id = azurerm_app_service_plan.web-sp.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}

# Create an index.html file
resource "azurerm_storage_account" "web-sa" {
  name                     = "sal-storageaccount"
  location            = azurerm_resource_group.web-site.location
  resource_group_name = azurerm_resource_group.web-site.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "web-sto-con" {
  name                  = "$web"
  storage_account_name  = azurerm_storage_account.web-sa.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "web-sto-blpb" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.web-sa.name
  storage_container_name = azurerm_storage_container.web-sto-con.name
  type                   = "Block"
  content_type           = "text/html"
  source_content         = file("${path.module}/index.html")
}

# Output the web app URL
output "web_app_url" {
  value = azurerm_app_service.example.default_site_hostname
}