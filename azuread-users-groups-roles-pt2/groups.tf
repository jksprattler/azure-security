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

resource "azuread_group" "Engineering" {
  display_name     = "Engineering"
  security_enabled = true
}

# Loop through all users and for each user assigned to the Engineering department assign their membership to the Engineering group:
resource "azuread_group_member" "Engineering" {
  for_each = { for u in local.users : u.mail_nickname => u if u.department == "Engineering" }

  group_object_id  = azuread_group.Engineering.id
  member_object_id = azuread_user.users[each.key].id
}
