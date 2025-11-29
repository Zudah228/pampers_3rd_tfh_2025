import 'dart:typed_data';

import 'package:app/core/exceptions/message_exception.dart';
import 'package:app/core/service/firebase_auth/firebase_auth_service.dart';
import 'package:app/core/service/firebase_firestore/firebase_firestore_service.dart';
import 'package:app/core/service/firebase_firestore/models/firestore_collections.dart';
import 'package:app/core/service/firebase_storage/firebase_storage_service.dart';
import 'package:app/core/service/firebase_storage/storage_paths.dart';
import 'package:app/features/photo/models/photo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

final addPhotoUseCaseProvider = Provider<AddPhotoUseCase>(
  AddPhotoUseCase.new,
);

class AddPhotoUseCase {
  const AddPhotoUseCase(this._ref);
  final Ref _ref;

  Future<Photo> call({
    required String roomId,
    required Uint8List data,
    DateTime? capturedAt,
  }) async {
    final userId = _ref.read(firebaseAuthServiceProvider).currentUser?.uid;

    if (userId == null) {
      throw AuthenticateException();
    }

    final firestore = _ref.read(firebaseFirestoreServiceProvider).firestore;
    final createdAt = capturedAt ?? DateTime.now();

    // 同じルーム・同じユーザーの写真を取得
    final existingPhotosSnapshot = await firestore
        .collection(FirestoreCollections.photos)
        .where('room_id', isEqualTo: roomId)
        .where('user_id', isEqualTo: userId)
        .get();

    // 同じ日付の写真が既に存在するかチェック
    final targetDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

    for (final doc in existingPhotosSnapshot.docs) {
      final docData = doc.data();
      final existingCreatedAt = docData['created_at'] as Timestamp?;

      if (existingCreatedAt != null) {
        final existingDate = existingCreatedAt.toDate();
        final existingDateOnly = DateTime(
          existingDate.year,
          existingDate.month,
          existingDate.day,
        );

        if (existingDateOnly == targetDate) {
          throw MessageException('この日付の写真は既に登録済みです');
        }
      }
    }

    final photoDocumentReference = firestore
        .collection(FirestoreCollections.photos)
        .withPhotoConverter
        .doc();
    final photoId = photoDocumentReference.id;

    final path = await _ref
        .read(firebaseStorageServiceProvider)
        .uploadImage(StoragePaths.room_photos(roomId), data);

    final photo = Photo(
      id: photoId,
      roomId: roomId,
      userId: userId,
      path: path,
      createdAt: createdAt,
      updatedAt: createdAt,
    );

    await photoDocumentReference.set(photo);

    return photo;
  }
}
