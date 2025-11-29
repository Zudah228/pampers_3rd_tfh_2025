import 'package:app/core/service/firebase_firestore/firebase_firestore_service.dart';
import 'package:app/core/service/firebase_firestore/models/firestore_collections.dart';
import 'package:app/features/auth/providers/current_user_provider.dart';
import 'package:app/features/room/models/room.dart';
import 'package:app/features/room/models/room_relation.dart';
import 'package:riverpod/riverpod.dart';

final myRoomProvider = StreamProvider.autoDispose<Room?>((ref) {
  final userId = ref.watch(currentUserProvider).id;

  if (userId == null) {
    return Stream.empty();
  }

  final firestore = ref.read(firebaseFirestoreServiceProvider).firestore;

  return firestore
      .collection(FirestoreCollections.roomRelations(userId))
      .withRoomRelationConverter
      .where(RoomRelationKeys.enabled, isEqualTo: true)
      .orderBy(RoomRelationKeys.createdAt, descending: true)
      .limit(1)
      .snapshots()
      .asyncMap((snapshot) async {
        final roomRelation = snapshot.docs.firstOrNull?.data();
        final roomId = snapshot.docs.firstOrNull?.id;

        if (roomId == null) {
          return null;
        }

        final roomSnapshot = await firestore
            .collection(FirestoreCollections.rooms)
            .withRoomConverter
            .doc(roomId)
            .get();
        return roomSnapshot.exists
            ? roomSnapshot.data()?.copyWith(
                enabled: roomRelation?.enabled ?? true,
              )
            : null;
      });
});
