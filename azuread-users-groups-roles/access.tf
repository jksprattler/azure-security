provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}
data "azurerm_resource_group" "artgroup" {
  name = azurerm_resource_group.artgroup.name
}

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
  principal_id       = azuread_group.Engineering.object_id
  description        = "Custom storage role for managing tf state blob"

  depends_on = [azurerm_role_definition.Custom_storage_tfstate_role_def]

}

# Provision Azure built-in role assignments
resource "azurerm_role_assignment" "Reader_role_all" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.Readers.object_id

}

resource "azurerm_role_assignment" "Contributor_role_art" {
  scope                = data.azurerm_resource_group.artgroup.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.Art.object_id

  depends_on = [data.azurerm_resource_group.artgroup]

}

# Azure AD Conditional Access Policy
resource "azuread_conditional_access_policy" "Art_access_policy" {
  display_name = "Art policy"
  state        = "enabled"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
      excluded_applications = []
    }

    users {
      included_groups = [azuread_group.Art.id]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}
