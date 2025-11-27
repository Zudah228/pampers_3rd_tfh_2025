import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/misc.dart';

extension RiverpodBuildContextExtension on BuildContext {
  T watch<T>(ProviderListenable<T> provider) {
    return ProviderScope.containerOf(this).read(provider);
  }

  T read<T>(ProviderListenable<T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }
}
