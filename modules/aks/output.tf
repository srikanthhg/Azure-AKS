output "config" {
    description = "Kubeconfig file for connecting to AKS cluster"
    value       = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].client_certificate
  sensitive = true
}
