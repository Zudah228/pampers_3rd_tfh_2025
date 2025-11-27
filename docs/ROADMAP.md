## データモデルの実装
Firestore で使用する、データモデルの実装。
以下のパッケージでデータモデルを作成する。

- freezed 
- json_serializable 

### 実装サンプル
- [`user.dart`](lib/features/user/models/user.dart)

### 実装手順
[スニペット](.vscode/flutter_freezed.code-snippets) で `"freezed"` と打ち込めば、Firestore に必要な実装が生成される。

<video controls="true" src="assets/freezed_snippets.mov" />

## Firestore の実装


## 入力フォームの実装
`CustomFormBase`/ ウィジェットとその State を継承した、`[FeatureName]Form` と `[FeatureName]FormState` を実装。

```dart
class UserForm extends CustomFormBase<User> {
  UserForm({super.key});

  UserFormState createState() => UserFormState();
}

class UserFormState extends CustomFormBaseState {

}
```