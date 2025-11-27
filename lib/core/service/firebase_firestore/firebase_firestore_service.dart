import 'package:app/core/service/firebase_firestore/models/firestore_paginated_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

final firebaseFirestoreServiceProvider = Provider.autoDispose(
  (Ref ref) => FirebaseFirestoreService(FirebaseFirestore.instance),
);

class FirebaseFirestoreService {
  const FirebaseFirestoreService(this.firestore);

  final FirebaseFirestore firestore;

  Future<FirestorePaginatedList<T>> page<T>({
    required Query<T> query,
    required int limit,
    Object? startAfter,
  }) async {
    var ref = query.limit(limit);

    if (startAfter is DocumentSnapshot) {
      ref = ref.startAfterDocument(startAfter);
    } else if (startAfter != null) {
      ref = ref.startAfter([startAfter]);
    }

    final querySnapshot = await ref.get();
    final items = querySnapshot.docs.map((doc) {
      return FirestoreDocument(data: doc.data(), snapshot: doc);
    }).toList();

    return FirestorePaginatedList(items: items, hasMore: items.length >= limit);
  }
}

extension FirebaseFirestoreServiceExtension on Ref {
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      watch(firebaseFirestoreServiceProvider).firestore.collection(path);
}
