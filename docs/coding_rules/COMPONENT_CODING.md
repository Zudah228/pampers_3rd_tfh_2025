# コンポーネントの設計のルール
切り分けたコンポーネント、共通化するコンポーネントのルール。

## ウィジェット引数として、表示するためだけの String、IconData は使わない

### ❌ NG

拡張性が低い

```dart
class TextInfo {
  const TextInfo({
    super.key,
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 24)
        ),
      ],
    );
  }
}
```

### ⭕️ OK
すべて `Widget` で受け取る。
スタイルやサイズを設定したい場合は、`IconTheme.merge` や `DefaultTextStyle.merge` などを使う。

```dart
class TextInfo {
  const TextInfo({
    super.key,
    required this.text,
    required this.icon,
  });

  final Widget text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconTheme.merge(
          data: IconThemeData(
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          chid: icon,
        ),
        DefaultTextStyle.merge(
          style: TextStyle(fontSize: 24),
          child: text,
        ),
      ],
    );
  }
}
```

URL を開く動作を含んでいたり、`Semantics` や `Tooltip` の関係で `String` にしたい場合などはその限りではない。
（しかし、文字列と Widget の両方を設定できる設計にするのが好ましい）

```dart
class LinkText extends StatelessWidget {
  const LinkText({
    super.key,
    required this.url,
    this.child,
  });

  final String url;
  final Widget? child;

  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyle(
        color: Colors.blue,
      ),
      child: child ?? Text(url),
    );
  }
}
```

## `Expanded` などの `ParentDataWidget` を返さない
### ❌ NG
```dart
class UserImage extends StatelessWidget {
  const UserImage({super.key});

  Widget build(BuildContext context) {
    return Expanded(
      // ...
    );
  }
}
```

[ParentDataWidget](https://api.flutter.dev/flutter/widgets/ParentDataWidget-class.html) は、特定の親ウィジェットを強制するウィジェット。

`ParentDataWidget` の例
- Expanded (Column/Row/Flex)
- Flexible (Column/Row/Flex)
- Positioned (Stack)
- SliverCrossAxisExpanded (SliverMainAxisGroup/SliverCrossAxisGroup)
- etc...

これらを、対象のウィジェット以外の子に置くいてしまうと、エラーが発生してしまう。
使う側の考慮事項が増え、使い勝手の悪いコンポーネントになってしまう。

### ❌ OK
`ParentDataWidget` は、使う側が設定する。

このこのルールを守ることで結果的に、実装の可読性の向上が期待できる。
たとえば `Expanded` は、「`Column` でどういう振る舞いをするか」を定義するウィジェットなので、切り分けない方が調整しやすい。
```dart
Column(
  children: [
    Expanded(
      child: UserImage(),
    ),

    // ...
  ]
)
```

例外として、プライベートで意図が明確な場合などは、ある程度許容することも考えられる。
（ほとんどの場合、その必要はない）


## 余白を設けない
### ❌ NG
```dart
class UserImage extends StatelessWidget {
  const UserImage({super.key});

  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),

        Image(
          // ...
      ],
    );
  }
}
```
```dart
class UserImage extends StatelessWidget {
  const UserImage({super.key});

  Widget build(BuildContext context) {
    return Padding(
      padding: .all(16),
      child: Image(
        // ...
    );
  }
}
```

### ⭕️ OK
コンポーネントは、そのまま並べると隣と接するように設計し、
使う側が余白を設定するようにする。

しかし、以下の場合では許容することも考えられる。
- タップ領域を確保したい場合
- 用途が限定位的なコンポーネントで、余白が設けられることが予測できる
- 周囲に影を表示するための領域を確保するため
- `Scrollable.ensureVisible` などで自然なスクロールをさせるために、ある程度の余白が必要な場合

## PrimaryScroll を意識する

ひとつのページに、１つの Scrollable なら問題ないが、`IndexedStack` などで表示切り替えなどをして、複数の Scrollable を扱う場合、PrimaryScroll を意識して開発する。

build 関数内で、今表示中であるかを監視して、各スクローラブルウィジェットの `primary` キーに `true` を渡すようにする。

```dart
  final isCurrentTab = ref.watch(mainTabProvider) == MainTab.myPage;

  return SingleChildScrollView(
    primary: isCurrentTab,
```

## 同じ意味の state を作らない
状態を変数で管理する場合、同じ意味の state を複数作らない。

### ❌ NG

```dart
final textEditingController = useTextEditingController();
final text = useState();

TextField(
  controller: textEditingController,
  onChanged: (value) {
    text.value = value;
  }
)

Text(text.value);
```

### ⭕️ OK

```dart
final textEditingController = useTextEditingController();

TextField(
  controller: textEditingController,
)


ValueListenableBuilder(
  valueListenable: textEditingController,
  builder: (context, value, _) {
    return Text(value.text);
  },
);
```
```dart
final textEditingController = useTextEditingController();
useListenable(textEditingController);

TextField(
  controller: textEditingController,
)

Text(textEditingController.text);
```
