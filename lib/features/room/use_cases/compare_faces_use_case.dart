import 'dart:typed_data';

import 'package:app/core/service/firebase_functions/firebase_functions_service.dart';
import 'package:app/core/service/firebase_storage/firebase_storage_service.dart';
import 'package:app/core/service/firebase_storage/storage_paths.dart';
import 'package:riverpod/riverpod.dart';

final compareFacesUseCaseProvider = Provider<CompareFacesUseCase>(
  CompareFacesUseCase.new,
);

class CompareFacesUseCase {
  const CompareFacesUseCase(this._ref);
  final Ref _ref;

  Future<bool> call({
    required String roomId,
    required Uint8List data,
  }) async {
    final storage = _ref.read(firebaseStorageServiceProvider);
    final filePath = await storage.uploadImage(
      StoragePaths.room_faces(roomId),
      data,
    );
    final functions = _ref.read(firebaseFunctionsServiceProvider);

    final result = await functions.call(
      FirebaseFunctionNames.compareFaces,
      {
        'room_id': roomId,
        'file_path': filePath,
      },
    );

    return (result['success'] as bool);
  }
}
