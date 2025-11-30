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
  - ダッシュボードで docs/ のドキュメントを指標にしている

## Flutter 
- アーキテクチャは feature-first を採用
  - layer-first で保たれる整合性より、他人とのバッティングが起きづらく、開発速度への耐性が高いと判断している
- Riverpod による状態管理
  - riverpod_generator は採用していない
    - 昨今のアップデートにより、冗長性がかなり軽減されたため
    - コード生成の手間、Provider参照のしづらさがあるため
  - 非同期の取得、アーキテクチャ設計に使用
  - State/Notifier は極力使わず、ウィジェットに閉じた変数管理を行う
  - その他の方針は、［docs/coding_rules/PACKAGE_CODING.md](docs/coding_rules/PACKAGE_CODING.md)に明記している
