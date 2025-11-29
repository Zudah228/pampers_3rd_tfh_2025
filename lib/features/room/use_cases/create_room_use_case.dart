import 'package:app/core/exceptions/message_exception.dart';
import 'package:app/core/service/firebase_auth/firebase_auth_service.dart';
import 'package:app/core/service/firebase_firestore/firebase_firestore_service.dart';
import 'package:app/core/service/firebase_firestore/models/firestore_collections.dart';
import 'package:app/features/room/models/room.dart';
import 'package:app/features/room/models/room_relation.dart';
import 'package:riverpod/riverpod.dart';

final createRoomUseCaseProvider = Provider.autoDispose<CreateRoomUseCase>(
  CreateRoomUseCase.new,
);

class CreateRoomUseCase {
  const CreateRoomUseCase(this._ref);
  final Ref _ref;

  Future<Room> call({int maxCount = 2}) async {
    final userId = _ref.read(firebaseAuthServiceProvider).currentUser?.uid;

    if (userId == null) {
      throw AuthenticateException();
    }

    final firestore = _ref.read(firebaseFirestoreServiceProvider).firestore;
    final roomDocumentReference = firestore
        .collection(FirestoreCollections.rooms)
        .withRoomConverter
        .doc();

    final room = Room(
      id: roomDocumentReference.id,
      createdBy: userId,
      maxCount: 2,
      currentCount: 1,
    );
    final roomRelation = RoomRelation(
      id: roomDocumentReference.id,
      userId: userId,
    );

    await firestore.runTransaction((transaction) async {
      transaction
        ..set(roomDocumentReference, room)
        ..set(
          firestore
              .collection(FirestoreCollections.roomRelations(userId))
              .withRoomRelationConverter
              .doc(roomDocumentReference.id),
          roomRelation,
        );
    });

    return room;
  }
}
