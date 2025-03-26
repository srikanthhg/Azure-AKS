terraform {
    backend "azurerm" {
    # client_id = module.service_principal.client_id
    # client_secret = module.service_principal.client_secret
    resource_group_name  = "mytestrg"
    storage_account_name = "myexpsa"
    container_name       = "mytestcontainer"
    key                  = "test.terraform.tfstate"
  }
}