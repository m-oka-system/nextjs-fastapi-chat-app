## 共通

- コードに変更を加えたあとは以下のコマンドを実行すること
  - terraform validate
  - terraform fmt -recursive
  - terraform plan
  - terraform init (Module 追加 / Backend 更新 / バージョン変更時)

## 命名規則

- Azure リソースの命名は、以下のドキュメントを参考に命名すること
- ただし `azurecaf` プロバイダー自体は使用しなくて構いません

- https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
- https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name

```bash
# 命名規則の例
<resource_type>-<project>-<environment>
<resource_type>-<purpose>-<project>-<environment>
```

### 命名規則の詳細

- **map 変数のキー設計**: マップのキーは用途（purpose）を表し、リソース名の一部として使用する
- **name フィールドの冗長性回避**: map 変数でキーと同じ値の`name`フィールドは定義しない
- **実装例**:

  ```hcl
  # 推奨: キーを直接使用
  name = "snet-${each.key}-${var.project}-${var.environment}"

  # 非推奨: 冗長なnameフィールド
  pe = { name = "pe", ... }  # キーと重複
  ```

## コーディングルール

- 設計書 (/docs/design.md) を元に実装してください
- インプット変数は variables.tf に定義してください
- ローカル変数は locals.tf に定義してください
- 出力値は outputs.tf に定義してください
- ユーザーがアクセスする、ドメイン、エンドポイント、IP アドレスのみ outputs.tf に記述してください
- DRY 原則に従ってください
- 機密情報は terraform.tfvars に記述してください (ハードコーディングしないでください)

### locals.tf vs 直接定義の判断基準

- **locals.tf に定義する場合**:
  - 複数のリソースで参照される値（例: 共通タグ）
  - 複雑な計算式や条件分岐を含む値
  - プロジェクト全体で一意性を保つ必要がある値
- **リソースブロック内で直接定義する場合**:
  - 単一リソースでのみ使用される命名規則
  - 可読性を重視したい場合
  - リソース特有の設定値

### DRY 原則と for_each 活用

- for_each または dynamic ブロックを活用して冗長コードを排除してください (例：Subnet、Network Security Group)
- インプット変数はリソースや属性ごとにグルーピングして map 形式で定義してください
- map 変数のキーと値の重複を避け、キーを命名規則の一部として活用してください

```hcl
# map 形式でグルーピングする例
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
    pe = {
      # nameフィールドは削除（キーを使用）
      address_prefixes                  = ["10.0.2.0/24"]
      default_outbound_access_enabled   = true
      private_endpoint_network_policies = "Enabled"
      service_delegation                = null
    }
    appservice = {
      address_prefixes                  = ["10.0.1.0/24"]
      default_outbound_access_enabled   = true
      private_endpoint_network_policies = "Disabled"
      service_delegation = {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
    appgw = {
      address_prefixes                  = ["10.0.3.0/24"]
      default_outbound_access_enabled   = true
      private_endpoint_network_policies = "Disabled"
      service_delegation                = null
    }
  }
}

# リソースでの使用例
resource "azurerm_subnet" "main" {
  for_each = var.subnets

  # キーを直接使用して命名規則を適用
  name = "snet-${each.key}-${var.project}-${var.environment}"
  address_prefixes = each.value.address_prefixes
  # その他の設定...
}
```

### NSG の例も同様に最適化：

```hcl
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
  # nameフィールドを削除し、キーのみで管理
}
```

## 調査方法

ベストプラクティスや不明点に関する調査は以下のルールに従ってください。

- Azure のベストプラクティスは microsoft.docs mcp を使用して調査してください。
- Terraform のベストプラクティスは terraform / microsoft.docs mcp を使用して調査してください。
- 調査結果を報告する時は、根拠となる URL を合わせて提示してください。
