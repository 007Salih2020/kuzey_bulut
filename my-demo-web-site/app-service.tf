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