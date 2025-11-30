import 'package:app/core/service/firebase_firestore/firebase_firestore_service.dart';
import 'package:app/features/auth/providers/current_user_provider.dart';
import 'package:app/features/room/models/room_relation.dart';
import 'package:app/features/room/providers/my_room_provider.dart';
import 'package:app/features/user/models/user.dart';
import 'package:riverpod/riverpod.dart';

/// ルームメンバーのユーザー情報を取得するプロバイダー
final roomMembersProvider = StreamProvider.autoDispose<List<User>>((ref) {
  final myRoom = ref.watch(myRoomProvider).value;
  final currentUserId = ref.watch(currentUserProvider).id;

  if (myRoom == null || currentUserId == null) {
    return Stream.value([]);
  }

  final firestore = ref.read(firebaseFirestoreServiceProvider).firestore;

  // collectionGroupを使ってルームIDに一致するroom_relationsを取得
  return firestore
      .collectionGroup('related_rooms')
      .where('id', isEqualTo: myRoom.id)
      .where(RoomRelationKeys.enabled, isEqualTo: true)
      .snapshots()
      .asyncMap((snapshot) async {
        final userIds = snapshot.docs
            .map((doc) => doc.data()['user_id'] as String?)
            .whereType<String>()
            .toList();

        if (userIds.isEmpty) {
          return <User>[];
        }

        // 各ユーザー情報を取得
        final userDocs = await Future.wait(
          userIds.map(
            (userId) => firestore
                .collection('users')
                .withUserConverter
                .doc(userId)
                .get(),
          ),
        );

        return userDocs
            .where((doc) => doc.exists)
            .map((doc) => doc.data()!)
            .toList();
      });
});

/// 現在のユーザー情報を取得するプロバイダー
final currentUserInfoProvider = StreamProvider.autoDispose<User?>((ref) {
  final currentUserId = ref.watch(currentUserProvider).id;

  if (currentUserId == null) {
    return Stream.value(null);
  }

  final firestore = ref.read(firebaseFirestoreServiceProvider).firestore;

  return firestore
      .collection('users')
      .withUserConverter
      .doc(currentUserId)
      .snapshots()
      .map((snapshot) => snapshot.data());
});

/// パートナーのユーザー情報を取得するプロバイダー
final partnerUserProvider = StreamProvider.autoDispose<User?>((ref) {
  final members = ref.watch(roomMembersProvider).value ?? [];
  final currentUserId = ref.watch(currentUserProvider).id;

  if (currentUserId == null || members.isEmpty) {
    return Stream.value(null);
  }

  // 自分以外のメンバーを取得
  final partner = members.firstWhere(
    (user) => user.id != currentUserId,
    orElse: () => members.first,
  );

  return Stream.value(partner);
});
