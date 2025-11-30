import 'package:app/core/service/firebase_firestore/firebase_firestore_service.dart';
import 'package:app/core/service/firebase_firestore/models/firestore_collections.dart';
import 'package:app/core/utils/riverpod/firestore_provider.dart';
import 'package:app/features/photo/models/photo.dart';
import 'package:app/features/room/providers/my_room_provider.dart';

/// ルームの写真一覧を取得するプロバイダー
final photosProvider = FirestoreProvider.page.create<Photo>(
  (ref, startAfter) {
    final room = ref.watch(myRoomProvider).value;
    
    if (room == null) {
      throw Exception('ルームが見つかりません');
    }

    return ref
        .read(firebaseFirestoreServiceProvider)
        .page(
          query: ref
              .read(firebaseFirestoreServiceProvider)
              .firestore
              .collection(FirestoreCollections.photos)
              .withPhotoConverter
              .where(PhotoKeys.roomId, isEqualTo: room.id)
              .orderBy(PhotoKeys.createdAt, descending: true),
          startAfter: startAfter,
          limit: 50,
        );
  },
);

