// Resource Group
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "rg-vnet-hub-prod-001"
  location = var.location

  tags = {
    environment = var.environment_tag
  }
}

// Marketplace agreement.
// if allready exists error occurs, run following:
// terraform import azurerm_marketplace_agreement.sophos_agree "/subscriptions/9561adc1-4585-4110-9645-0323f841560c/providers/Microsoft.MarketplaceOrdering/agreements/sophos/offers/sophos-xg/plans/byol"
resource "azurerm_marketplace_agreement" "sophos_agree" {
  publisher = "sophos"
  offer     = "sophos-xg"
  plan      = var.license_type
}