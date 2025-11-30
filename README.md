# ｛アプリ名｝
スクリーンショット

## 環境
- フレームワーク等
  - Flutter 3.38.3
    - Riverpod v3.x
  - Cloud Functions
    - Node.js(TypeScript)
- CI/レビュー
  - GitHub Actions
  - Code rabbit
- タスク管理
  - Linear

## ディレクトリ構成


## GitHub のルール
### ブランチ管理
- ブランチ名は、Linear のタスクIDで命名する（feature/ 等の prefix は不要）
  - これにより、PR作成時にLinearが自動で連携してくれる
- タスクを切っていない場合は、正確に内容を表した名前にする

### レビュー
基本的に、coderabbit によるレビュー指摘に従う。
反論がある場合は、会話による解決をしたうえでコメントを Resolveする（こうすることで、正しい指摘を無視するリスクを軽減する）。

## CI/レビュー
- GitHub Actions でフォーマット、警告やエラーの確認を行なっている

- coderabbit のレビューにより、コードの生合成を保つ
  - ダッシュボードで docs/ のパスを

## Flutter 
- Riverpod
