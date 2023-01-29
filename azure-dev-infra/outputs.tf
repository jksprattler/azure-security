output "sub_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}

output "app_id" {
  value = resource.azuread_service_principal.gh-actions-runbooks-ad.application_id
}

# Retrieve secret: terraform output -raw auth_client_secret
output "auth_client_secret" {
  value       = azuread_service_principal_password.gh-actions-runbooks-ad.value
  description = "output password"
  sensitive   = true
}
