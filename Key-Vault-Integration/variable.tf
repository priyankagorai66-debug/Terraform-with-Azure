variable "resource_group_name" {
    type        = string
    default = "RG-keyvault-demo"
}

variable "location" {
    type        = string
    default = "Central India"
}

variable "key_vault_name" {
    type        = string
    default = "kv-priya-terraform"
}

variable "secret_name" {
    type        = string
    default = "secret-demo"
}

variable "secret_value" {
    type       = string
    default = "SuperSecret123!"
}