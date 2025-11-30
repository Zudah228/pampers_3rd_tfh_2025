import 'dart:typed_data';

import 'package:riverpod/riverpod.dart';

final unlockProvider = Provider.autoDispose<UnlockService>(
  (ref) => UnlockService(),
);

class UnlockService {
  /// 画像を解析してロック解除を試みる
  ///
  /// TODO: 以下の処理を実装
  /// - 画像の解析を行い、二人が写っているかどうかを判断する
  /// - 二人が本人かどうかの解析を行う
  /// - 解析が成功した場合は、ロック解除する
  /// - 解析が失敗した場合は、エラーをthrowする
  Future<void> unlock(Uint8List imageData) async {
    // 現在は画像が投稿されたかのみを判定
    // TODO: 実際の画像解析処理を実装

    // 仮の処理: 少し待機してロック解除成功とする
    await Future<void>.delayed(const Duration(seconds: 3));

    // TODO: 実際のロック解除処理を実装
  }
}
