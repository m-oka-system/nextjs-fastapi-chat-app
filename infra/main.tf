terraform {
  required_version = ">= 1.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      # Azure Key Vault の論理削除を無効にする
      purge_soft_delete_on_destroy = true
    }
    resource_group {
      # リソースグループ内にリソースがあっても削除する
      prevent_deletion_if_contains_resources = false
    }
  }
}

# INFRA-001: リソースグループの作成
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location

  tags = local.common_tags
}

# INFRA-002: Virtual Network (VNet) の作成
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project}-${var.environment}"
  address_space       = var.virtual_network.address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.common_tags
}

# INFRA-003-005: サブネットの作成 (for_eachを使用)
resource "azurerm_subnet" "main" {
  for_each = var.subnets

  name                              = "snet-${each.key}"
  resource_group_name               = azurerm_resource_group.main.name
  virtual_network_name              = azurerm_virtual_network.main.name
  address_prefixes                  = each.value.address_prefixes
  default_outbound_access_enabled   = each.value.default_outbound_access_enabled
  private_endpoint_network_policies = each.value.private_endpoint_network_policies

  dynamic "delegation" {
    for_each = each.value.service_delegation != null ? [each.value.service_delegation] : []
    content {
      name = "Microsoft.Web.serverFarms"
      service_delegation {
        name    = delegation.value.name
        actions = delegation.value.actions
      }
    }
  }
}

# INFRA-006-008: NSGの作成 (for_eachを使用)
resource "azurerm_network_security_group" "main" {
  for_each = var.network_security_groups

  name                = "nsg-${each.key}-${var.project}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      destination_port_ranges    = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = local.common_tags
}

# NSGをサブネットに関連付け (for_eachを使用)
resource "azurerm_subnet_network_security_group_association" "main" {
  for_each = var.network_security_groups

  subnet_id                 = azurerm_subnet.main[each.key].id
  network_security_group_id = azurerm_network_security_group.main[each.key].id
}

# INFRA-009-013: Private DNS Zoneの作成
resource "azurerm_private_dns_zone" "main" {
  for_each = var.private_dns_zones

  name                = each.value
  resource_group_name = azurerm_resource_group.main.name

  tags = local.common_tags
}

# INFRA-014: VNetとPrivate DNS Zoneのリンク設定
resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  for_each = var.private_dns_zones

  name                  = "link-${each.key}-${var.project}-${var.environment}"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.main[each.key].name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false

  tags = local.common_tags
}
