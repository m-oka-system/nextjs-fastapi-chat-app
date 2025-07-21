## プロジェクト基本情報

このプロジェクトはユーザーの質問に対して AI が応答する ChatGPT 風の Web アプリケーションです。

## 技術仕様

### フロントエンド

- **フレームワーク**: Next.js 14 (App Router)
- **言語**: TypeScript
- **スタイリング**: TailwindCSS
- **UI コンポーネント**: shadcn/ui
- **アイコン**: Lucide React
- **状態管理**: React hooks（useState, useEffect）
- **API 通信**: Fetch API with EventSource（SSE 用）

### バックエンド

- **フレームワーク**: FastAPI
- **言語**: Python 3.11+
- **非同期処理**: asyncio
- **ストリーミング**: Server-Sent Events (SSE)
- **認証**: Azure AD token validation

### インフラストラクチャ

- **ホスティング**: Azure App Service (Linux Container)
- **コンテナレジストリ**: Azure Container Registry
- **データベース**: Azure Cosmos DB (Core SQL API)
- **AI/ML**: Azure OpenAI Service
- **シークレット管理**: Azure Key Vault
- **ロードバランサー**: Azure Application Gateway
- **IaC**: Terraform

## 共通コマンド

- `npm run build`: プロジェクトのビルド実行
- `pytest tests/`: テストスイート実行
- `black .`: コードフォーマット適用
- `terraform validate`: Terraform の構文チェック
- `terraform fmt -recursive`: Terraform のフォーマット適用

## コードスタイル

- ES6 モジュール構文（import/export）を使用
- 可能な限り分割代入を活用
- 関数名は snake_case、クラス名は PascalCase で統一

## ワークフロー

- 変更完了後は必ず型チェックを実行
- 全テストではなく単体テストを優先して実行

## Terraform コーディングルール

- @.github/instructions/generate-modern-terraform-code-for-azure.instructions.md
- @.github/instructions/azure.md

ベストプラクティスや不明点に関する調査は以下のルールに従ってください。

- Azure のベストプラクティスは microsoft.docs mcp を使用して調査してください。
- Terraform のベストプラクティスは terraform / microsoft.docs mcp を使用して調査してください。
- 調査結果を報告する時は、根拠となる URL を合わせて提示してください。
