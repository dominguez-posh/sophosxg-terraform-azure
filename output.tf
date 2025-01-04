output "ResourceGroup" {
  value = azurerm_resource_group.myterraformgroup.name
}

output "Sophos-Web-Login" {
  value = "https://${azurerm_public_ip.SFOSPublicIp.ip_address}:4444" 
}

output "Username" {
  value = "admin"
}

output "Password" {
  value     = random_password.SfosPW.result
  sensitive = true
}