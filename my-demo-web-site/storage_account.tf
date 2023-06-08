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
