# Create a resource group
resource "azurerm_resource_group" "web-site" {
  name     = "sal-rg-website"
  location = "West Europe"
}
 
 