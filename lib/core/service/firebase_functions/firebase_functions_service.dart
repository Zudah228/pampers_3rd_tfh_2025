import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod/riverpod.dart';

final firebaseFunctionsServiceProvider = Provider.autoDispose(
  (Ref ref) => FirebaseFunctionsService(
    FirebaseFunctions.instanceFor(
      region: 'asia-northeast1',
    ),
  ),
);

class FirebaseFunctionsService {
  const FirebaseFunctionsService(this._functions);

  final FirebaseFunctions _functions;

  Future<Map<String, dynamic>> call(
    String functionName, [
    Map<String, dynamic>? parameters,
  ]) async {
    final result = await _functions
        .httpsCallable(functionName)
        .call<Map<String, dynamic>>(parameters);

    return _castMap(result.data)! as Map<String, dynamic>;
  }

  // NOTE(tsuda): Firebase Functions の返却値が Map<Object?, Object?> のため、
  // 再起的に Map<String, dynamic> に変換する。
  Object? _castMap(Object? element) {
    if (element is Map) {
      return element.map(
        (key, value) {
          return MapEntry(key as String, _castMap(value));
        },
      );
    }

    if (element is List) {
      return element.map(_castMap).toList();
    }

    return element;
  }
}

abstract final class FirebaseFunctionNames {
  const FirebaseFunctionNames._();

  static const compareFaces = 'compareFaces';
}
