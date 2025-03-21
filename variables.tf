variable "SUB_ID" {
  type    = string
  default = "2cab150b-4433-4b0e-95a8-fabb980b3485"
}

variable "rgname" {
  type    = string
  default = "ForAKS"
}

variable "location" {
  default = "eastus"
}

variable "service_principal_name" {
  type    = string
  default = "myAppforAKS"
}

variable "aks_name" {
  type        = string
  description = "The name of the AKS cluster"
  default     = "myAKSdemocluster"
}


variable "keyvault_name" {
  type    = string
  default = "myspkeyvault"
}

variable "kubernetes_version" {
  type    = string
  default = ""
}