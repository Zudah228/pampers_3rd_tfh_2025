import 'package:app/core/exceptions/message_exception.dart';
import 'package:app/core/service/firebase_auth/firebase_auth_service.dart';
import 'package:app/core/service/firebase_firestore/firebase_firestore_service.dart';
import 'package:app/core/service/firebase_firestore/models/firestore_collections.dart';
import 'package:app/features/room/models/room.dart';
import 'package:app/features/room/models/room_relation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

final joinRoomUseCaseProvider = Provider.autoDispose<JoinRoomUseCase>(
  JoinRoomUseCase.new,
);

class JoinRoomUseCase {
  const JoinRoomUseCase(this._ref);
  final Ref _ref;

  Future<Room> call(String roomId) async {
    final userId = _ref.read(firebaseAuthServiceProvider).currentUser?.uid;

    if (userId == null) {
      throw AuthenticateException();
    }

    final firestore = _ref.read(firebaseFirestoreServiceProvider).firestore;

    return firestore.runTransaction<Room>((transaction) async {
      final roomDocumentReference = firestore
          .collection(FirestoreCollections.rooms)
          .withRoomConverter
          .doc(roomId);

      final snapshot = await transaction.get(roomDocumentReference);
      if (!snapshot.exists) {
        throw MessageException('ルームが存在しません');
      }

      final room = snapshot.data()!;

      final currentCount = room.currentCount + 1;

      if (currentCount >= room.maxCount) {
        throw MessageException('ルームの制限を超えています');
      }

      transaction
        ..update(roomDocumentReference, {
          RoomKeys.currentCount: currentCount,
          RoomKeys.updatedAt: FieldValue.serverTimestamp(),
        })
        ..set(
          firestore
              .collection(FirestoreCollections.roomRelations(userId))
              .withRoomRelationConverter
              .doc(roomId),
          RoomRelation(id: roomId, userId: userId),
        );

      return room;
    });
  }
}
