# Provision Azure AD Users
resource "azuread_user" "Roy_Trenneman" {
  user_principal_name   = "roytrenneman@jennasrunbooks.com"
  display_name          = "Roy Trenneman"
  department            = "Engineering"
  password              = "Super$ecret01@!"
  force_password_change = true
}

resource "azuread_user" "Bob_Ross" {
  user_principal_name   = "bobross@jennasrunbooks.com"
  display_name          = "Bob Ross"
  department            = "Art"
  password              = "Super$ecret01@!"
  force_password_change = true
}

resource "azuread_user" "raybrown" {
  user_principal_name   = "raybrown@jennasrunbooks.com"
  display_name          = "Ray Brown"
  department            = "Art"
  password              = "Super$ecret01@!"
  force_password_change = true
}

# Provision Azure AD Groups
data "azuread_client_config" "current" {}

resource "azuread_group" "Readers" {
  display_name     = "Readers"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  types            = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "user.userPrincipalName -contains \"jennasrunbooks\""
  }
}

resource "azuread_group" "Engineering" {
  display_name     = "Engineering"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  types            = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "user.department -eq \"Engineering\""
  }
}

resource "azuread_group" "Art" {
  display_name     = "Art"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  types            = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "user.department -eq \"Art\""
  }
}
