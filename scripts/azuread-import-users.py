#########################################################################
# Extract a list of Azure AD user Display Names, Principal Names and 
# Departments from your current ARM_SUBSCRIPTION_ID and generate Terraform 
# code to be pasted into the main.tf file of this directory for managing AD users
#########################################################################

import os
import csv

azureadusers = os.system('az ad user list --query "[].{name:displayName, userPrincipalName:userPrincipalName, department:department}" -o tsv > azureadusers.tsv')
azureadtsv = open("azureadusers.tsv")
read_azureadtsv = csv.reader(azureadtsv, delimiter="\t")

azureadusers
for col in read_azureadtsv: 
    display_name_nospace = col[0].replace(" ", "")
    print ('resource "azuread_user" "' + display_name_nospace + '" {')
    print('  user_principal_name   = "' + col[1] + '"')
    print('  display_name          = "' + col[0] + '"')
    print('  department            = "' + col[2] + '"') 
    print("}")
    print ()
azureadtsv.close()
