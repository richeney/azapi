terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.1"
    }

    azapi = {
      source  = "azure/azapi"
      version = "~>0.1"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "central_workspace" {
  name                = "centralWorkspace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azapi_resource" "example_dcr" {
  name      = "example"
  parent_id = azurerm_resource_group.example.id
  type      = "Microsoft.Insights/dataCollectionRules@2021-04-01"
  location  = var.location
  body = templatefile("example.dcr.json.tftpl", {
    "workspace_id" : azurerm_log_analytics_workspace.central_workspace.id
  })
}

resource "azapi_resource" "example_dcr_association" {
  name      = "example"
  parent_id = azurerm_linux_virtual_machine.example.id
  type      = "Microsoft.Insights/dataCollectionRuleAssociations@2021-04-01"
  body      = jsonencode({
    properties = {
      dataCollectionRuleId = azapi_resource.example_dcr.id
    }
  })
}

output "workspace_id" {
  value = azurerm_log_analytics_workspace.central_workspace.id
}

output "dcr_id" {
  value = azapi_resource.example_dcr.id
}

output "dcr_association_id" {
  value = azapi_resource.example_dcr_association.id
}