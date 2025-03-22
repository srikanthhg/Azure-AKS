resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.location
}

module "service_principal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [azurerm_resource_group.rg1]
}

resource "azurerm_role_assignment" "example" {
  scope                = "/subscriptions/${var.SUB_ID}"
  role_definition_name = "Contributor"
  principal_id         = module.service_principal.service_principal_object_id

  depends_on = [module.service_principal]
}

module "keyvault" {
  source                      = "./modules/Keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.service_principal.service_principal_object_id
  service_principal_tenant_id = module.service_principal.service_principal_tenant_id
  

  depends_on = [
    module.service_principal
  ]
}

resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = module.keyvault.keyvault_id
  tenant_id    = module.service_principal.service_principal_tenant_id
  object_id    =  module.service_principal.service_principal_object_id

  secret_permissions = [
    "Get", "List", "Set" 
  ]

}

resource "azurerm_key_vault_secret" "example" {
  name         = module.service_principal.client_id
  value        = module.service_principal.client_secret
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [ 
    module.keyvault
  ]
}

module "aks" {
  source                 = "./modules/aks"
  location               = var.location
  aks_name               = var.aks_name
  resource_group_name    = var.rgname
  kubernetes_version     = var.kubernetes_version
  service_principal_name = var.service_principal_name
  client_id              = module.service_principal.client_id
  client_secret          = module.service_principal.client_secret
  node_pool_name = var.node_pool_name

  depends_on = [
    azurerm_resource_group.rg1,
    module.service_principal,
    module.keyvault,
    azurerm_key_vault_secret.example
  ]
}

# resource "local_file" "foo" {
#   content  = module.aks.config
#   filename = "./kubeconfig"
#   depends_on = [ module.aks ]
# }