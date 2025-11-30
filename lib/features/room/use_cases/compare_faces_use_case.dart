import 'package:app/core/service/firebase_functions/firebase_functions_service.dart';
import 'package:riverpod/riverpod.dart';

final compareFacesUseCaseProvider = Provider.autoDispose<CompareFacesUseCase>(
  CompareFacesUseCase.new,
);

class CompareFacesUseCase {
  const CompareFacesUseCase(this._ref);
  final Ref _ref;

  Future<bool> call({
    required String roomId,
    required String filePath,
  }) async {
    final functions = _ref.read(firebaseFunctionsServiceProvider);

    final result = await functions.call(
      FirebaseFunctionNames.compareFaces,
      {
        'roomId': roomId,
        'filePath': filePath,
      },
    );

    return (result['success'] as bool);
  }
}
