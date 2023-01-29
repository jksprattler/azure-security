resource "random_uuid" "gh-actions-runbooks-id" {}

resource "azuread_application" "gh-actions-runbooks-ad" {
  display_name = "gh-actions-runbooks-ad"
  owners       = [data.azuread_client_config.current.object_id]

  api {
    mapped_claims_enabled          = true
    requested_access_token_version = 2

    known_client_applications = []

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access GH Actions on behalf of the signed-in user."
      admin_consent_display_name = "Access GH Actions"
      enabled                    = true
      id                         = random_uuid.gh-actions-runbooks-id.result
      type                       = "User"
      user_consent_description   = "Allow the application to access GH Actions on your behalf."
      user_consent_display_name  = "Access GH Actions"
      value                      = "user_impersonation"
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    # All permissions and IDs: https://learn.microsoft.com/en-us/graph/permissions-reference#all-permissions-and-ids
    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }

    resource_access {
      id   = "5b567255-7703-4780-807c-7be8301ae99b" # Group.Read.All
      type = "Role"
    }

    resource_access {
      id   = "dbb9058a-0e50-45d7-ae91-66909b5d4664" # Domain.Read.All
      type = "Role"
    }

    #resource_access {
    #  id   = "b4e74841-8e56-480b-be8b-910348b18b4c" # User.ReadWrite
    #  type = "Scope"
    #}

    resource_access {
      id   = "9a5d68dd-52b0-4cc2-bd40-abcf44ac3a30" # Application.Read.All
      type = "Role"
    }

    resource_access {
      id   = "19dbc75e-c2e2-444c-a770-ec69d8559fc7" # Directory.ReadWrite.All
      type = "Role"
    }

    resource_access {
      id   = "246dd0d5-5bd0-4def-940b-0421030a5b68" # Policy.Read.All
      type = "Role"
    }

    resource_access {
      id   = "01c0a623-fc9b-48e9-b794-0756f8e8f067" # Policy.ReadWrite.ConditionalAccess
      type = "Role"
    }

  }

  web {

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }
}

resource "azuread_service_principal" "gh-actions-runbooks-ad" {
  application_id = azuread_application.gh-actions-runbooks-ad.application_id
}

resource "azuread_service_principal_password" "gh-actions-runbooks-ad" {
  service_principal_id = azuread_service_principal.gh-actions-runbooks-ad.object_id
}

resource "azurerm_role_assignment" "gh-actions-runbooks-ad-reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.gh-actions-runbooks-ad.object_id
}
