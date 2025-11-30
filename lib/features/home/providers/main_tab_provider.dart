import 'package:flutter_riverpod/legacy.dart';

enum MainTab {
  home,
  settings
  ;

  String get label => switch (this) {
    home => 'ホーム画面',
    settings => '設定画面',
  };
}

final mainTabProvider = StateProvider.autoDispose<MainTab>((ref) {
  return MainTab.home;
});
