variable "project" {
  description = "プロジェクト名（リソース名のプレフィックスとして使用）"
  type        = string
  default     = "aidriven"
}

variable "environment" {
  description = "環境名"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "デプロイリージョン"
  type        = string
  default     = "Japan East"
}

variable "virtual_network" {
  description = "Virtual Networkの設定"
  type = object({
    address_space = list(string)
  })
  default = {
    address_space = ["10.0.0.0/16"]
  }
}

variable "subnets" {
  description = "サブネットの設定"
  type = map(object({
    address_prefixes                  = list(string)
    default_outbound_access_enabled   = bool
    private_endpoint_network_policies = string
    service_delegation = optional(object({
      name    = string
      actions = list(string)
    }))
  }))
  default = {
    appservice = {
      address_prefixes                  = ["10.0.1.0/24"]
      default_outbound_access_enabled   = true
      private_endpoint_network_policies = "Disabled"
      service_delegation = {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
    pe = {
      address_prefixes                  = ["10.0.2.0/24"]
      default_outbound_access_enabled   = true
      private_endpoint_network_policies = "Enabled"
      service_delegation                = null
    }
    appgw = {
      address_prefixes                  = ["10.0.3.0/24"]
      default_outbound_access_enabled   = true
      private_endpoint_network_policies = "Disabled"
      service_delegation                = null
    }
  }
}

variable "network_security_groups" {
  description = "Network Security Groupの設定"
  type = map(object({
    security_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      destination_port_range     = optional(string)
      destination_port_ranges    = optional(list(string))
      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)
    }))
  }))
  default = {
    appservice = {
      security_rules = [
        # 受信規則: なし
        {
          name                       = "DenyAllInbound"
          priority                   = 4096
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        # 送信規則
        {
          name                       = "AllowPrivateEndpointOutbound"
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "10.0.2.0/24"
        },
        {
          name                       = "AllowInternetOutbound"
          priority                   = 110
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "Internet"
        },
        {
          name                       = "DenyAllOutbound"
          priority                   = 4096
          direction                  = "Outbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
    pe = {
      security_rules = [
        # 受信規則
        {
          name                       = "AllowAppServiceSubnetInbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "10.0.1.0/24"
          destination_address_prefix = "VirtualNetwork"
        },
        {
          name                       = "AllowApplicationGatewayInbound"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "10.0.3.0/24"
          destination_address_prefix = "VirtualNetwork"
        },
        {
          name                       = "DenyAllInbound"
          priority                   = 4096
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        # 送信規則
        {
          name                       = "DenyAllOutbound"
          priority                   = 4096
          direction                  = "Outbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
    appgw = {
      security_rules = [
        # 受信規則
        {
          name                       = "AllowCorpNetInbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "192.168.0.0/24" # 社内ネットワーク（仮）
          destination_address_prefix = "VirtualNetwork"
        },
        {
          name                       = "AllowAzureLoadBalancer"
          priority                   = 4095
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "AzureLoadBalancer"
          destination_address_prefix = "*"
        },
        {
          name                       = "DenyAllInbound"
          priority                   = 4096
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        # 送信規則
        {
          name                       = "AllowPrivateEndpointOutbound"
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "10.0.2.0/24"
        },
        {
          name                       = "DenyAllOutbound"
          priority                   = 4096
          direction                  = "Outbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
  }
}

variable "private_dns_zones" {
  description = "Private DNS Zone の設定"
  type        = map(string)
  default = {
    cosmos_db          = "privatelink.documents.azure.com"
    key_vault          = "privatelink.vaultcore.azure.net"
    container_registry = "privatelink.azurecr.io"
    openai             = "privatelink.openai.azure.com"
    app_service        = "privatelink.azurewebsites.net"
  }
}
