## アプリ概要

ユーザーの質問に応答する ChatGPT 風のアプリを作成したい。

## 要求事項

- 質問を入力して送信ボタンを押したら、ストリーム形式で回答を表示すること
- ユーザーがモデルを選択、切り替えできること
- ユーザーごとのチャットの履歴を確認できること
- 回答が長い場合は自動的に画面スクロールすること

シンプルな機能のみあれば良いので、以下のような機能は必要ありません。

- マルチモーダル
- 外部参照 (RAG)

## 技術スタック

以下の技術スタックを使用して開発を進めてください。
Next.js プロジェクトは `create-next-ap` を使用して作成済みです。

```bash
npx create-next-app@14 . --typescript --eslint --tailwind --src-dir --app --import-alias "@/*"
npx shadcn@latest init --base-color slate
npx shadcn@latest add button
```

- Next.js (App Router)
- TypeScript
- FastAPI
- TailwindCSS
- shadcn/ui
- Lucide React

## インフラ

アプリが必要とするホスティング環境、データストア、GPT モデルは以下の Azure サービスを使用してください。

- Application Gateway (プライベート)
- App Service (Linux for Container)
- Container Registry
- Cosmos DB
- OpenAI Service
- Key Vault

次の要求を満たすようにインフラを構成してください。

- Terraform でコーディングすること (infra/)
- Terraform Modules は使用せず maint.tf にすべてのインフラを記述すること
- なるべくコストの安い SKU を選択すること
- PaaS への接続はプライベートエンドポイントを使用してセキュアに接続できるようにすること
- API キーなどの機密情報は Key Vault に保存すること

## 作業指示

ドキュメントは /docs に保存してください。

- 最初に要件を洗い出して requirements.md として要件定義書を作成してください。
- 要件を決定するために確認すべき事項はユーザーに質問して丁寧に確認を取ってください。
- Azure のベストプラクティスは microsoft.docs mcp を使用して調査してください。
- 作成した要件定義書を元に design.md として設計書を作成してください。
- インフラのネットワーク構成図は mermaid 記法を用いて視覚的にわかりやすく記述してください。
- 作成した設計書を元に task.md としてタスクを作成してください。
- タスクは実装が複雑化しないようになるべく小さい粒度で作成してください。
- Terraform のベストプラクティスは terraform / microsoft.docs mcp を使用して調査してください。
- Linter を使用してコードの品質を点検すること
