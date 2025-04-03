# https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-install-new
# github.io/Azure/application-gateway-ingress-controller/blob/master/docs/setup/install.mod

#---------------------------------------------------
# The jsonencode() function converts a map to a JSON string, and jsondecode() then converts that JSON string back into a map.
locals{
    parameters = jsonencode({
        "clientId": "${module.service_principal.client_id}",
        "clientSecret": "${module.service_principal.client_secret}",
        "tenantId": "${module.service_principal.service_principal_tenant_id}",
        "subscriptionId": "${var.SUB_ID}",
    })
}

resource "helm_release" "AGIC" {
  name       = "application-gateway-ingress-controller"
  repository = "https://myexpsa.blob.core.windows.net/mytestcontainer"
  chart      = "ingress-azure"
  version    = "1.8.0" 
  namespace  = "default" 
  timeout    = "600"
  cleanup_on_fail  = true
  recreate_pods    = true
  replace          = true

  set {
    name  = "verbosityLevel"
    value = "3"
  }
  set {
    name  = "appgw.subscriptionId"
    value = "${var.SUB_ID}"
  }
  set {
    name  = "appgw.resourceGroup"
    value = "${var.rgname}"
  }
  set {
    name  = "appgw.name"
    value = "${module.appgw.appgw_name}"
  }
  set {
    name  = "appgw.shared"
    value = "false"
  }

  set {
    name  = "armAuth.type"
    value = "servicePrincipal"
  }
  set {
    name  = "armAuth.secretJSON"
    value = base64encode(local.parameters) # Pass the entire JSON-encoded string
  }

  set {
    name  = "armAuth.identityClientID"
    value = "${module.service_principal.client_id}"
  }
  set {
    name  = "rbac.enabled"
    value = "true"
  }
  depends_on = [ module.appgw,module.aks]
}