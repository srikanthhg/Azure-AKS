# Role assignments
resource "azurerm_role_assignment" "ra1" {
    scope                = azurerm_resource_group.rg1.id
    role_definition_name = "Contributor" #Reader
    principal_id         = module.service_principal.service_principal_object_id
}

resource "azurerm_role_assignment" "ra2" {
    scope                = module.vnet.vnet_id
    role_definition_name = "Network Contributor"
    principal_id         = module.service_principal.service_principal_object_id
}

resource "azurerm_role_assignment" "ra3" {
    scope                = module.appgw.appgw_id
    role_definition_name = "Contributor"
    principal_id         = module.service_principal.service_principal_object_id
}