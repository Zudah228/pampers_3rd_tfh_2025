import 'package:flutter_riverpod/legacy.dart';

enum MainTab {
  home,
  settings
  ;

  String get label => switch (this) {
    home => 'Home',
    settings => 'Settings',
  };
}

final mainTabProvider = StateProvider.autoDispose<MainTab>((ref) {
  return MainTab.home;
});
