locals {
  domain_name = data.azuread_domains.aad_domains.domains.1.domain_name
  users       = csvdecode(file("${path.module}/users.csv"))
}

resource "azuread_user" "users" {
  for_each = { for user in local.users : user.mail_nickname => user }
  user_principal_name = format(
    "%s@%s",
    lower(each.value.mail_nickname),
    local.domain_name
  )

  password = format(
    "%s%s%s!123",
    lower(each.value.last_name),
    substr(lower(each.value.first_name), 0, 1),
    length(each.value.first_name)
  )
  force_password_change = true
  display_name          = "${each.value.first_name} ${each.value.last_name}"
  department            = each.value.department
  job_title             = each.value.job_title
  preferred_language    = each.value.preferred_language
  usage_location        = each.value.usage_location
  show_in_address_list  = false
}
