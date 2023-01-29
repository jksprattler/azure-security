provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}
data "azurerm_resource_group" "artgroup" {
  name = azurerm_resource_group.artgroup.name
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
