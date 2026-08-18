# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Fetch details of the current Azure client (your logged-in identity)
data "azurerm_client_config" "current" {}

#key vault
resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  rbac_authorization_enabled = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]
  }
}
# Secret in key vault
resource "azurerm_key_vault_secret" "secret" {
  name         = var.secret_name
  value        = var.secret_value 
  key_vault_id = azurerm_key_vault.kv.id
}

# Storage Account using secret as tag
resource "azurerm_storage_account" "storage" {
  name                     = "priyankastorageacct123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    secret_value = azurerm_key_vault_secret.secret.value
  }
}
