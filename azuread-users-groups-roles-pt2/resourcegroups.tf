# Deploy RG's and resources for RBAC testing
resource "azurerm_resource_group" "artgroup" {
  name     = "artgroup"
  location = "eastus2"
}