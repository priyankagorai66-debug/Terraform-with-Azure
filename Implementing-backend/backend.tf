terraform {

  backend "azurerm" {
    resource_group_name  = "MyRG-terraform"
    storage_account_name = "priyankaterraformsa123"
    container_name       = "mycontainer"
    key                  = "terraform.tfstate"

  }

}
