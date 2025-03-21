terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.23.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.1.0"
    }
  }
  required_version = ">=1.9.0"

  backend "azurerm" {
    # client_id = module.service_principal.client_id
    # client_secret = module.service_principal.client_secret
    resource_group_name  = "testrg"
    storage_account_name = "myexpensesa"
    container_name       = "myexpensecontainer"
    key                  = "testcluster.terraform.tfstate"
  }

}

provider "azurerm" {
  # Configuration options
  #   resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  subscription_id = var.SUB_ID
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
      #   recover_soft_deleted_key_vaults = true
    }
  }
}
provider "azuread" {

}