#########################################################################
# Prompt for new Azure AD users Display name (First Last), Principal name
# and Department then generates the terraform code to be pasted into 
# main.tf for new user creation
#########################################################################

import subprocess as sp

# Request input from user for Display name, Principal name and Department
userPrincipalName = input("User principal name prior to @jennasrunbooks.com (ex. bobross): ")
domainName = sp.getoutput("az rest --method get --url https://graph.microsoft.com/v1.0/domains --query 'value[?isDefault].id' -o tsv")
displayName = input("User display name (ex. Bob Ross): ")
departmentName = input("User department (ex. Art): ")
print () 

print ('resource "azuread_user" "' + userPrincipalName + '" {')
print('  user_principal_name   = "' + userPrincipalName, '@', domainName, sep='')
print('  display_name          = "' + displayName + '"')
print('  department            = "' + departmentName + '"') 
print('  password              = "Super$ecret01@!"')
print('  force_password_change = true') 
print("}")
print ()
