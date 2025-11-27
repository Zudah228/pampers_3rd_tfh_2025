# 主要なパッケージの使い方
アプリ全体で使用する、主要なパッケージそれぞれの使い方や考え方のガイドライン。

## freezed
データクラスの実装に便利なパッケージだが、パッケージ依存やビルドランナーの削減の観点で、できるだけ使わないようにする。

### freezed が有用な場合
- json_serializable を併用した、`fromJson/toJson` の生成が必要
- copyWith が必要
  - ⚠️ メンバ変数が少ない場合や、AI による生成で事足りる場合もある

### freezed が不要な場合
- freezed で生成される機能（`copyWith/toString/== operator`）をほぼ使わない
- `== operator` のためだけに使う
  - `Record` や、`== operator` の自前実装を検討する

## Riverpod
> [!note]
> macro の開発中止により、コード生成の重要性が下がった。
> 加えて、Riverpod のアプデにより、手で Provider を定義するコストもかなり下がったので、本アプリでは手動実装を採用。
> さらに、スニペットで補助している。
> 
> https://github.com/rrousselGit/riverpod/issues/4008

- `TextEditingController` や `FocusNode` など、ウィジェットと紐づくものは、ライフサイクルとの同期などが困難なので、状態として Provider で持つのは禁止
- 徒に状態を持つ `Provider` を実装せず、ウィジェットに状態として持つ
  - バケツリレーを受け入れる
  - `InheritedWidget` 、`of` 関数を自作して活用する
- 状態がひとつの関数で表現できる場合は、 `Notifier/AsyncNotifier` を使わず、`Provider/FutureProvider` で実装する

### Notifier/StateNotifier Provider の使用は慎重に
離れたウィジェット同士で状態を共有できるのが便利な点であるが、同時に **コードが密結合するリスク**があることを意識する。

過度な使用は、可読性・変更容易性・テスト容易性を重大に損なう。
よって、基本的に Notifier/StateNotifier Provider を使用するケースは多く発生しない。
`StatefulWidget` や `flutter_hooks` で閉じた状態にすることを検討する。

#### Notifier/StateNotifier Provider が許容しやすいケース
- 他のウィジェットから参照することが容易に想像できるケース
  - ボトムバーがどこを選択しているか
  - ログインしているユーザーの情報
- 検索のフィルターなど、Provider の変更によって、他の Provider を発火させたいケース

以上のケースに当てはまらず必要になった場合は、状態を持つ必要がある理由を、必ずコメントで明記する。
その場合、不用意に更新されないように、更新元をコメントで明記するか、NotifierProvider で関数を設計する。

例）
```dart
// HomePage に表示する必要があるため、State を管理している。
final selectedImageUrlProvider StateProvider.autoDispose<String?>(
  {ref} => null,
);
```

#### Notifier/StateNotifier Provider を避けた方がいいケースの例
- ❌ モーダルなどの別ページで、項目を選択させるために実装する
  ```dart
  class SelectItemModal extends ConsumerWidget {

    // ...
    onTap: () {
      ref.read(selectedItemprovider.notifier)state = item;
    }
  }
  ```
  ⭕️ ↓ Navigator を使用して値を受け取る形にする。
  ```dart
  final item = await SelectItemModal.show(context);
  ```
  ```dart
  await SelectItemModal.show(context, onSelected: (item) => _selectedItem = item );
  ```
- ❌ バケツリレーを避けるためだけに実装する
  ```dart
  final userPageStateProvider = NotifierProvider.autoDispose // ...
  ```
  ⭕️ ↓ バケツリレーを許容するか、`InheritedWidget`、`context.findAncestorStateOfType` でコード量を削減する。
  ```dart
  class _Selector extends StatelesWidget {
    const _Selector({
      required this.value,
      required this.onChanged,
    });

    final String value;
    final ValueChanged<String> onChanged;
  }
  ```

### .select による部分監視
Provider を `.select` をつけることで照準を絞り、リビルドを抑えることができる。
```dart
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // userProvider が更新されていても、`userid` に変化がなければリビルドが走らない
    final userId = ref.watch(userProvider.select((value)  => value.userId));
```

もし「リビルドを抑える」ことを第一優先にすれば、複数のメンバ変数を抱えるクラスの Provider を参照する場合、`.select` を複数回実行することが理にかなってしまう。

しかし、可読性や実装コストが嵩んでしまうので、この書き方は推奨しない。

❌ NG
```dart
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userProvider.select((value)  => value.userId));
    final userName = ref.watch(userProvider.select((value)  => value.name));
```

⭕️ OK
```dart
final user = ref.watch(userProvider);
final userId = user.userId;
final userName = user.name;
```

リビルドの抑制ではなく、あくまで、変数のスコープを絞るという目的で使うのが好ましい
```dart
// user.name は参照したいが、あくまで isEmpty が知れるだけでいい
final isUserNameEmpty = ref.watch(userProvider.select(
  (value)  => value.name.isEmpty),
);
```



## Flutter Hooks
コード記述量の削減、Listenable の自動 dispose 、アニメーションの実装コスト削減を目的としている。

- `core/app/components/` などの共通コンポーネントでは、必ず `StatefulWidget` を使用する
  - パッケージ依存やウィジェットの拡張性（`GlobalKey` や `findAncestorStateOfType` による `State` との連携）を考慮
- よく使うものや、自動 dispose を実装したい場合は `core/app/hooks/` にカスタムフックスを実装する
- useEffect
  - 初期表示の目的で利用する場合は、カスタムフックスの `useEffectOnce` を利用する
  - 本来の、副作用やリスナーの監視のために利用する場合は、１つにまとめず目的に合った複数の `useEffect` を実装する
    `useEffect` の上に、コメントで目的を書いておくと丁寧
    ```dart
    // Add comment for implements.
    useEffect(
      () {
        void listener() {
          // some implements
        }

        scrollController.addListener(listener);
        return () => scrollController.removeLister(listener);
      },
      [scrollController],
    );

    // Add comment for implements.
    useEffect(
      () {
        // some implements using someValue.
      },
      [someValue],
    );
    ```
