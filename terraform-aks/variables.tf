variable "SUB_ID" {
  type    = string
}

variable "rgname" {
  type    = string
}

variable "location" {
  type    = string
}

variable "service_principal_name" {
  type    = string
}
variable "node_pool_name" {
  type    = string
}
variable "aks_name" {
  type        = string
  description = "The name of the AKS cluster"
}


variable "keyvault_name" {
  type    = string
}

variable "kubernetes_version" {
  type    = string
  default = ""
}