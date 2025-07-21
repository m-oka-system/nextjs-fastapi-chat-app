# User Assigned Managed Identity outputs
output "user_assigned_identity_id" {
  description = "ユーザー割り当てマネージドIDのID"
  value       = azurerm_user_assigned_identity.main.id
}

output "user_assigned_identity_principal_id" {
  description = "ユーザー割り当てマネージドIDのプリンシパルID（ロール割り当てに使用）"
  value       = azurerm_user_assigned_identity.main.principal_id
}

output "user_assigned_identity_client_id" {
  description = "ユーザー割り当てマネージドIDのクライアントID"
  value       = azurerm_user_assigned_identity.main.client_id
}

output "user_assigned_identity_tenant_id" {
  description = "ユーザー割り当てマネージドIDのテナントID"
  value       = azurerm_user_assigned_identity.main.tenant_id
}
