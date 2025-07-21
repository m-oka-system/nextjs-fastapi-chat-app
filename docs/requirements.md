# ChatGPT 風アプリケーション要件定義書

## 1. 目的

本ドキュメントは、ChatGPT 風アプリを Azure 上で安全かつ低コストに運用するためのインフラ要件を定義します。
開発・運用メンバーが共通認識を持ち、Terraform コードを作成する際の指針とします。

## 2. システム概要

ユーザーが質問を入力すると、選択した GPT モデルがストリーム形式で回答を返すチャットアプリです。
ユーザーはモデルを切り替えられ、過去のチャット履歴をいつでも確認できます。

## 3. 技術スタック

### 3.1 フロントエンド

- **フレームワーク**: Next.js 14 (App Router)
- **言語**: TypeScript
- **スタイリング**: TailwindCSS
- **UI コンポーネント**: shadcn/ui
- **アイコン**: Lucide React
- **状態管理**: React hooks（useState, useEffect）
- **API 通信**: Fetch API with EventSource（SSE 用）

### 3.2 バックエンド

- **フレームワーク**: FastAPI
- **言語**: Python 3.11+
- **非同期処理**: asyncio
- **ストリーミング**: Server-Sent Events (SSE)
- **認証**: Azure AD token validation

## 4. インフラ

### 4.1 インフラ構成方針

- リージョンは東日本リージョンとする (OpenAI Service 除く)
- すべてのリソースを 1 つの Azure Virtual Network に配置し、サービス間通信はプライベートエンドポイントで閉域化します。（Container Registry を除く）
- 可能な限りコストの低い SKU を選択し、負荷に応じてスケールアウト・アップを検討します。
- API キーや接続文字列などの機密情報は Key Vault に保持し、マネージド ID 経由で参照します。
- 通信要件ごとに必要な通信のみを許可し、不要な通信は明示的に拒否します。
- ロールベースのアクセス制御 (RBAC) を使用して Azure リソースに対するアクセスを制御します。
- 最小特権の原則に従ってロールを割り当てます。
- Azure リソースにロールを割り当てる必要がある場合はマネージド ID を使用します。
- IaC ツールとして Terraform を使用し、インフラ構成をコードで管理します。
- Terraform コードは infra/main.tf 内に一元管理し、モジュールは基本的に使用しません。

### 4.2 Azure サービス

- Application Gateway (Basic / Private IP)
  - 内部ロードバランサとして使用し HTTPS を終端。WAF 機能はコスト優先のため今回は無効。
- App Service (Linux Container、プラン: Basic B1)
  - ひとつの App Service プランで 2 つの App Service (Next.js + FastAPI) を同居。小規模負荷を想定し最小プランを選択。
- Container Registry (Basic)
  - CI/CD でビルドしたアプリコンテナを保存。
- Cosmos DB (Core SQL、Serverless)
  - チャット履歴を保持。使用量ベース課金で小規模利用に最適。
- Azure OpenAI Service (Standard S0)
  - GPT‑4o などのモデルを利用。最新のモデルが使用できるリージョンを選定する。
- Key Vault (Standard)
  - 機密情報を集中管理し、プライベートアクセスを強制。

## 5. 機能一覧

### 5.1 チャット機能

- **質問入力と送信**

  - テキストエリアに質問を入力
  - 送信ボタンまたは Enter キーで送信
  - 送信中は入力を無効化

- **ストリーミング応答**
  - Azure OpenAI API からの応答をリアルタイムで表示
  - 文字が順次表示されるストリーミング形式
  - 応答中はローディングインジケーターを表示

### 5.2 モデル選択機能

- **利用可能モデル**

  - GPT-4o
  - o3（利用可能な場合）
  - その他 Azure OpenAI Service に登録されているモデル

- **モデル切り替え**
  - ドロップダウンメニューからモデルを選択
  - チャット中でも切り替え可能
  - 選択したモデルは次回アクセス時も保持

### 5.3 チャット履歴機能

- **履歴の保存**

  - ユーザーごとにチャット履歴を保存
  - Cosmos DB に永続化
  - 質問と回答のペアを時系列で管理

- **履歴の表示**
  - 過去の会話を時系列で表示
  - 各メッセージにタイムスタンプを表示
  - ユーザー/アシスタントを明確に区別

### 5.4 UI/UX 要件

- **レイアウト**

  - ChatGPT ライクなインターフェース
  - サイドバーなし、シンプルな単一カラムレイアウト
  - 上部にモデル選択、中央にチャット履歴、下部に入力エリア

- **自動スクロール**

  - 新しいメッセージ受信時に自動的に最下部へスクロール
  - ユーザーが手動でスクロールした場合は自動スクロールを一時停止

- **レスポンシブデザイン**
  - PC、タブレット、スマートフォンに対応
  - ブレークポイント: 768px（タブレット）、1024px（デスクトップ）

## 6. 非機能要件

### 6.1 認証・認可

- **認証方式**
  - Azure App Service Easy Auth（認証プロバイダー: Azure AD）
  - 認証されたユーザーのみアクセス可能
  - ユーザー ID を基にデータを分離

### 6.2 セキュリティ

- **シークレット管理**

  - Azure OpenAI API キーは Key Vault に格納
  - App Service から Managed Identity を使用して Key Vault にアクセス
  - Key Vault は RBAC でアクセス制御（アクセスポリシーは使用しない）

- **ネットワークセキュリティ**
  - すべての PaaS サービスへの接続は Private Endpoint を使用（Container Registry を除く）
  - Container Registry は CI/CD 環境からのプッシュのためパブリックアクセスを許可
  - Application Gateway を経由したアクセスのみ許可
  - NSG（ネットワークセキュリティグループ）による通信制御
    - ゼロトラストの原則に基づき、必要な通信のみを明示的に許可
    - その他のすべての通信は明示的に拒否（優先度 4096 の DenyAll ルール）

### 6.3 パフォーマンス

- **レスポンスタイム**

  - 初回応答開始まで 3 秒以内
  - ストリーミング中の遅延は最小限に

- **同時接続数**
  - 最大 100 ユーザーの同時利用を想定

### 6.4 可用性

- **稼働率目標**

  - 99%以上（計画メンテナンスを除く）

- **可用性ゾーン対応**
  - 可用性ゾーンをサポートするリージョンを選択する
  - コスト優先の観点から、初期段階では単一ゾーン構成とする
  - 以下のリソースは既定でゾーン冗長をサポート：
    - Application Gateway (v2 Basic SKU)
    - Key Vault (Standard SKU)
  - 将来的な拡張として、以下のリソースのゾーン冗長化を検討：
    - App Service (Premium プランへのアップグレード時)
    - Cosmos DB (ゾーン冗長レプリケーション)
    - Container Registry (Premium SKU へのアップグレード時)

## 7. データモデル

### 7.1 チャットメッセージ

```json
{
  "id": "uuid",
  "userId": "string",
  "conversationId": "uuid",
  "role": "user|assistant",
  "content": "string",
  "model": "string",
  "timestamp": "datetime",
  "tokenCount": "number"
}
```

### 7.2 会話セッション

```json
{
  "id": "uuid",
  "userId": "string",
  "title": "string",
  "createdAt": "datetime",
  "updatedAt": "datetime",
  "messageCount": "number"
}
```

## 8. API 仕様

### 8.1 チャット送信

- **エンドポイント**: `POST /api/chat/send`
- **リクエスト**:
  ```json
  {
    "message": "string",
    "model": "string",
    "conversationId": "uuid"
  }
  ```
- **レスポンス**: Server-Sent Events stream

### 8.2 履歴取得

- **エンドポイント**: `GET /api/chat/history`
- **パラメータ**:
  - `conversationId` (optional)
  - `limit` (default: 50)
  - `offset` (default: 0)
- **レスポンス**: メッセージの配列

### 8.3 モデル一覧取得

- **エンドポイント**: `GET /api/models`
- **レスポンス**: 利用可能なモデルの配列

## 9. 開発・運用要件

### 9.1 開発環境

- Node.js 20.x
- Python 3.11+
- Docker Desktop
- VS Code

### 9.2 CI/CD

- GitHub Actions
- コンテナビルドと ACR へのプッシュ
- App Service への自動デプロイ

### 9.3 監視・ログ

- Application Insights（基本的なメトリクス）
- エラーログの収集

## 10. 制約事項

### 10.1 機能制約

- マルチモーダル（画像、音声）非対応
- RAG（外部ドキュメント参照）非対応
- ファイルアップロード非対応
- 会話のエクスポート機能なし

### 10.2 技術制約

- Terraform Modules は使用しない
- すべてのインフラ定義は main.tf に記述
- コスト最適化のため最小限の SKU を使用

## 11. 今後の拡張可能性

- マルチ言語対応
- 会話の共有機能
- プロンプトテンプレート
- 使用量の可視化
- 管理者向けダッシュボード
- Azure Application Insights によるパフォーマンス監視
- 複数リージョンへの展開
- オートスケーリング機能
