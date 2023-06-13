variable "prefix" {
  default = "app-proxy"
}

variable "location" {
  default = "uksouth"
}

variable "vnet_address_space" {
  default = "10.1.0.0/24"
}
variable "subnet_address_space" {
  default = "10.1.0.0/25"
}

variable "size" {
  default = "Standard_D2ds_v5"
}

locals {
  tags = {
    environment  = "sandbox"
    builtFrom    = "timja local"
    application  = "core"
    businessArea = "Cross-Cutting"
    expiresAfter = "2023-06-20"
  }
}
