resource "azuread_group" "Readers" {
  display_name = "Readers"
  #owners           = [azuread_user.current.object_id]
  security_enabled = true
  types            = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "user.userPrincipalName -contains \"jennasrunbooks\""
  }
}

resource "azuread_group" "Engineering" {
  display_name = "Engineering"
  #owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  types            = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "user.department -eq \"Engineering\""
  }
}

resource "azuread_group" "Art" {
  display_name = "Art"
  #owners           = [azuread_user.current.object_id]
  security_enabled = true
  types            = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "user.department -eq \"Art\""
  }
}
