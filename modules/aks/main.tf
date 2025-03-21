data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_group_name}-cluster"
  kubernetes_version  = local.selected_kubernetes_version
  node_resource_group = "${var.resource_group_name}-nrg"

  sku_tier = "Free" # "Standard", "Premium" Defaults to "Free"
  automatic_upgrade_channel = "patch" # "patch", "rapid", "node-image", "stable" Defaults to "none"
  
  default_node_pool {
    name       = "defaultpool"
    vm_size    = "Standard_DS2_v2"
    auto_scaling_enabled = true
    min_count = 1
    max_count = 3
    os_disk_size_gb = 30
    type  = "VirtualMachineScaleSets"
    zones = [1, 2, 3]
    node_labels = {
        "nodepool-type"    = "system"
        "environment"      = "prod"
        "nodepools"       = "linux"
    }
    tags = {
        "nodepool-type"    = "system"
        "environment"      = "prod"
        "nodepools"       = "linux"
    }
  }
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = tls_private_key.rsa-4096-example.public_key_openssh
    }
  }

}

resource "tls_private_key" "rsa-4096-example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

