variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "azapi"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "UK South"
}

variable "vm_name" {
  description = "VM name"
  type        = string
  default     = "myVm"
}