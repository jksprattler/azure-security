# Azure custom role definitions
resource "azurerm_role_definition" "Custom_storage_tfstate_role_def" {
  name        = "CustomStoragetfStateRole"
  scope       = "${data.azurerm_subscription.current.id}/resourceGroups/centralus-jennasrunbookstf/providers/Microsoft.Storage/storageAccounts/jennasrunbookstfstate"
  description = "Custom storage role definition"

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/listKeys/action",
      "Microsoft.Storage/storageAccounts/regeneratekey/action",
      "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action"
    ]
    not_actions = []
  }
}

# Provision Azure custom role assignments
resource "azurerm_role_assignment" "Custom_storage_tfstate_role" {
  scope              = "${data.azurerm_subscription.current.id}/resourceGroups/centralus-jennasrunbookstf/providers/Microsoft.Storage/storageAccounts/jennasrunbookstfstate"
  role_definition_id = azurerm_role_definition.Custom_storage_tfstate_role_def.role_definition_resource_id
  principal_id       = azuread_service_principal.gh-actions-runbooks-ad.object_id
  description        = "Custom storage role for managing tf state blob"

  depends_on = [azurerm_role_definition.Custom_storage_tfstate_role_def]

}
