terraform {
  backend "azurerm" {
    resource_group_name  = "RG-keyvault-demo"
    storage_account_name = "priyankastorageacct123"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}