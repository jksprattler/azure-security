terraform {
  backend "azurerm" {
    resource_group_name  = "centralus-jennasrunbookstf"
    storage_account_name = "jennasrunbookstfstate"
    container_name       = "jennasrunbookstf"
    key                  = "azuread-apps-pt2-jennasrunbookstf.tfstate"
  }
}
