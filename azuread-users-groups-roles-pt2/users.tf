locals {
  # Capture the custom domain you want assigned to your User Principals
  domain_name = data.azuread_domains.aad_domains.domains.1.domain_name
  users       = csvdecode(file("${path.module}/users.csv"))
}

# Loop through the list of users in the block mapped to each line of the users.csv file
# The users.csv file requires: first_name,last_name,mail_nickname,preferred_language
# usage_location is required with Microsoft licenses assigned to a user
resource "azuread_user" "users" {
  # Define each user key by their unique mail nickname since potential first name duplicates are high
  for_each = { for user in local.users : user.mail_nickname => user }
  user_principal_name = format(
    "%s@%s",
    lower(each.value.mail_nickname),
    local.domain_name
  )
  
  # The new user will be created with an auto-generated password using the following pattern in all lowercase letters in a single string: 
  # lastname + first letter of first name + numerical value for length of first name + !123
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
