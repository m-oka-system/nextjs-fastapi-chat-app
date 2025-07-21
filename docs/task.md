# ChatGPT 風アプリケーション タスク一覧

## 1. インフラストラクチャ構築

### 1.1 基盤構築

- [ ] **INFRA-001**: リソースグループの作成 (東日本リージョン)
- [ ] **INFRA-002**: Virtual Network (VNet) の作成 (10.0.0.0/16, 東日本リージョン)
- [ ] **INFRA-003**: AppServiceSubnet の作成 (10.0.1.0/24)
- [ ] **INFRA-004**: PrivateEndpointSubnet の作成 (10.0.2.0/24)
- [ ] **INFRA-005**: ApplicationGatewaySubnet の作成 (10.0.3.0/24)
- [ ] **INFRA-006**: AppServiceSubnet NSG の作成と設定
- [ ] **INFRA-007**: PrivateEndpointSubnet NSG の作成と設定
- [ ] **INFRA-008**: ApplicationGatewaySubnet NSG の作成と設定

### 1.2 Private DNS Zone

- [ ] **INFRA-009**: privatelink.documents.azure.com の作成 (Cosmos DB 用)
- [ ] **INFRA-010**: privatelink.vaultcore.azure.net の作成 (Key Vault 用)
- [ ] **INFRA-011**: privatelink.azurecr.io の作成 (Container Registry 用, VNet 内アクセス用)
- [ ] **INFRA-012**: privatelink.openai.azure.com の作成 (OpenAI 用)
- [ ] **INFRA-013**: privatelink.azurewebsites.net の作成 (App Service 用)
- [ ] **INFRA-014**: VNet と Private DNS Zone のリンク設定

### 1.3 マネージド ID

- [ ] **INFRA-015**: ユーザー割り当てマネージド ID の作成

### 1.4 セキュリティリソース

- [ ] **INFRA-016**: Key Vault の作成 (Standard SKU, RBAC モード, ゾーン冗長対応)
- [ ] **INFRA-017**: Key Vault の Private Endpoint 作成
- [ ] **INFRA-018**: ユーザー割り当てマネージド ID に Key Vault Secrets User ロール付与

### 1.5 コンテナリソース

- [ ] **INFRA-019**: Container Registry の作成 (Basic SKU, パブリックアクセス許可)
- [ ] **INFRA-020**: Container Registry の管理者アカウント有効化
- [ ] **INFRA-021**: Container Registry の Private Endpoint 作成 (VNet 内からのアクセス用)
- [ ] **INFRA-022**: ユーザー割り当てマネージド ID に AcrPull ロール付与

### 1.6 データベース

- [ ] **INFRA-023**: Cosmos DB アカウントの作成 (Serverless)
- [ ] **INFRA-024**: conversations コンテナの作成 (パーティションキー: /userId)
- [ ] **INFRA-025**: messages コンテナの作成 (パーティションキー: /conversationId)
- [ ] **INFRA-026**: Cosmos DB の Private Endpoint 作成

### 1.7 AI/ML

- [ ] **INFRA-027**: OpenAI Service の作成 (Standard SKU, 最新モデル対応リージョン)
- [ ] **INFRA-028**: GPT-4o モデルのデプロイ (東日本以外のリージョンの可能性有り)
- [ ] **INFRA-029**: OpenAI Service の Private Endpoint 作成
- [ ] **INFRA-030**: OpenAI API キーを Key Vault に格納

### 1.8 アプリケーションホスティング

- [ ] **INFRA-031**: App Service Plan の作成 (B1 Basic)
- [ ] **INFRA-032**: App Service の作成 (Linux Container)
- [ ] **INFRA-033**: App Service にユーザー割り当てマネージド ID の割り当て
- [ ] **INFRA-034**: App Service の VNet Integration 設定
- [ ] **INFRA-035**: App Service の Private Endpoint 作成
- [ ] **INFRA-036**: App Service の Easy Auth (Azure AD) 設定

### 1.9 ネットワーク

- [ ] **INFRA-037**: Application Gateway の作成 (Basic v2 SKU, Preview, 東日本リージョン, ゾーン冗長対応)
- [ ] **INFRA-038**: Application Gateway のバックエンドプール設定
- [ ] **INFRA-039**: Application Gateway のヘルスプローブ設定
- [ ] **INFRA-040**: Application Gateway のルーティング規則設定

### 1.10 接続設定

- [ ] **INFRA-041**: Cosmos DB 接続文字列を Key Vault に格納
- [ ] **INFRA-042**: App Service に Key Vault 参照の設定

### 1.11 可用性とセキュリティ確認

- [ ] **INFRA-043**: Application Gateway のゾーン冗長設定確認
- [ ] **INFRA-044**: Key Vault のゾーン冗長設定確認
- [ ] **INFRA-045**: Private Endpoint 接続の動作確認
- [ ] **INFRA-046**: NSG 規則の適用とゼロトラスト設定確認

## 2. バックエンド開発 (FastAPI)

### 2.1 プロジェクトセットアップ

- [ ] **BACK-001**: FastAPI プロジェクトの初期化
- [ ] **BACK-002**: requirements.txt の作成
- [ ] **BACK-003**: プロジェクトディレクトリ構造の作成
- [ ] **BACK-004**: .env.example ファイルの作成

### 2.2 コア機能

- [ ] **BACK-005**: main.py の作成（FastAPI アプリケーション初期化）
- [ ] **BACK-006**: config.py の作成（環境変数読み込み）
- [ ] **BACK-007**: dependencies.py の作成（共通依存関係）
- [ ] **BACK-008**: security.py の作成（認証ミドルウェア）

### 2.3 データモデル

- [ ] **BACK-009**: chat.py モデルの作成（メッセージ、会話）
- [ ] **BACK-010**: user.py モデルの作成（ユーザー情報）
- [ ] **BACK-011**: Pydantic スキーマの定義

### 2.4 サービス層

- [ ] **BACK-012**: auth_service.py の作成（Azure AD トークン検証）
- [ ] **BACK-013**: openai_service.py の作成（OpenAI API 通信）
- [ ] **BACK-014**: cosmos_service.py の作成（Cosmos DB 操作）
- [ ] **BACK-015**: streaming.py の作成（SSE ストリーミング）

### 2.5 API エンドポイント

- [ ] **BACK-016**: health.py の作成（ヘルスチェック）
- [ ] **BACK-017**: models.py の作成（モデル一覧取得）
- [ ] **BACK-018**: chat.py ルーターの作成（チャット送信）
- [ ] **BACK-019**: chat.py に履歴取得エンドポイント追加

### 2.6 エラーハンドリング

- [ ] **BACK-020**: カスタム例外クラスの作成
- [ ] **BACK-021**: グローバルエラーハンドラーの実装
- [ ] **BACK-022**: ロギング設定の実装

## 3. フロントエンド開発 (Next.js)

### 3.1 プロジェクト設定

- [ ] **FRONT-001**: TypeScript 設定の調整
- [ ] **FRONT-002**: ESLint 設定の調整
- [ ] **FRONT-003**: Prettier 設定の追加
- [ ] **FRONT-004**: 環境変数設定ファイルの作成

### 3.2 型定義

- [ ] **FRONT-005**: types/index.ts の作成（共通型定義）
- [ ] **FRONT-006**: メッセージ型の定義
- [ ] **FRONT-007**: API レスポンス型の定義

### 3.3 ユーティリティ

- [ ] **FRONT-008**: api-client.ts の作成（API 通信）
- [ ] **FRONT-009**: auth.ts の作成（認証ヘルパー）
- [ ] **FRONT-010**: utils.ts の作成（共通ユーティリティ）

### 3.4 UI コンポーネント

- [ ] **FRONT-011**: shadcn/ui の追加コンポーネントインストール
- [ ] **FRONT-012**: MessageItem.tsx の作成
- [ ] **FRONT-013**: MessageList.tsx の作成
- [ ] **FRONT-014**: InputArea.tsx の作成
- [ ] **FRONT-015**: ModelSelector.tsx の作成

### 3.5 メインコンポーネント

- [ ] **FRONT-016**: ChatContainer.tsx の作成
- [ ] **FRONT-017**: layout.tsx の更新
- [ ] **FRONT-018**: page.tsx の実装（メインページ）
- [ ] **FRONT-019**: globals.css のスタイル調整

### 3.6 API Routes

- [ ] **FRONT-020**: api/auth/route.ts の作成
- [ ] **FRONT-021**: api/models/route.ts の作成
- [ ] **FRONT-022**: api/chat/route.ts の作成

### 3.7 SSE 実装

- [ ] **FRONT-023**: EventSource を使用したストリーミング実装
- [ ] **FRONT-024**: エラーハンドリングとリトライロジック
- [ ] **FRONT-025**: 接続状態管理の実装

## 4. Docker 化とデプロイ

### 4.1 コンテナ化

- [ ] **DEPLOY-001**: Dockerfile の作成（マルチステージビルド）
- [ ] **DEPLOY-002**: .dockerignore の作成
- [ ] **DEPLOY-003**: start.sh スクリプトの作成
- [ ] **DEPLOY-004**: docker-compose.yml の作成（ローカル開発用）

### 4.2 ビルドとプッシュ

- [ ] **DEPLOY-005**: Docker イメージのビルド
- [ ] **DEPLOY-006**: Container Registry へのプッシュ
- [ ] **DEPLOY-007**: イメージタグ管理戦略の実装

### 4.3 デプロイ設定

- [ ] **DEPLOY-008**: App Service のコンテナ設定
- [ ] **DEPLOY-009**: 環境変数の設定
- [ ] **DEPLOY-010**: ヘルスチェックの設定

## 5. テストと品質保証

### 5.1 単体テスト

- [ ] **TEST-001**: FastAPI エンドポイントのテスト作成
- [ ] **TEST-002**: サービス層のテスト作成
- [ ] **TEST-003**: フロントエンドコンポーネントのテスト作成

### 5.2 統合テスト

- [ ] **TEST-004**: API 統合テストの作成
- [ ] **TEST-005**: 認証フローのテスト
- [ ] **TEST-006**: ストリーミング機能のテスト

### 5.3 品質チェック

- [ ] **TEST-007**: ESLint の実行と修正
- [ ] **TEST-008**: Prettier によるコードフォーマット
- [ ] **TEST-009**: Python コードの linting (pylint/black)
- [ ] **TEST-010**: TypeScript の型チェック

## 6. 最終確認とドキュメント

### 6.1 動作確認

- [ ] **FINAL-001**: エンドツーエンドの動作確認
- [ ] **FINAL-002**: 認証フローの確認
- [ ] **FINAL-003**: チャット機能の確認
- [ ] **FINAL-004**: 履歴機能の確認

### 6.2 ドキュメント

- [ ] **FINAL-005**: README.md の作成
- [ ] **FINAL-006**: API ドキュメントの作成
- [ ] **FINAL-007**: デプロイ手順書の作成
- [ ] **FINAL-008**: トラブルシューティングガイドの作成

## 実装優先順位

1. **Phase 1**: インフラストラクチャ構築 (INFRA-001 ~ INFRA-046)
2. **Phase 2**: バックエンド基盤 (BACK-001 ~ BACK-011)
3. **Phase 3**: フロントエンド基盤 (FRONT-001 ~ FRONT-010)
4. **Phase 4**: API 実装 (BACK-012 ~ BACK-022, FRONT-020 ~ FRONT-025)
5. **Phase 5**: UI 実装 (FRONT-011 ~ FRONT-019)
6. **Phase 6**: デプロイ (DEPLOY-001 ~ DEPLOY-010)
7. **Phase 7**: テストと品質保証 (TEST-001 ~ TEST-010)
8. **Phase 8**: 最終確認 (FINAL-001 ~ FINAL-008)

## 注意事項

- 各タスクは依存関係を考慮して実行すること
- インフラ構築は Terraform で main.tf に一括記述
- セキュリティ設定（Private Endpoint、ユーザー割り当てマネージド ID）を確実に実施
- コスト最適化のため、指定された SKU を使用
- **デプロイリージョン**: 東日本 (Japan East) を使用
- **OpenAI Service**: 最新モデル対応のため東日本以外のリージョンを使用する可能性有り
- Application Gateway v2 Basic SKU（プレビュー）の登録が必要
- 東日本リージョンは可用性ゾーン対応リージョン
- ゾーン冗長設定の動作確認を必ず実施
- Linter によるコード品質チェックを必ず実施
