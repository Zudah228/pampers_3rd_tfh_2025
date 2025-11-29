import 'package:app/core/service/firebase_firestore/firebase_firestore_service.dart';
import 'package:app/core/service/firebase_firestore/models/firestore_collections.dart';
import 'package:app/core/utils/riverpod/firestore_provider.dart';
import 'package:app/features/debug_firestore/models/debug_item.dart';

final debugItemsProvider = FirestoreProvider.page.create<DebugItem>(
  (ref, startAfter) => ref
      .read(firebaseFirestoreServiceProvider)
      .page(
        query: ref
            .read(firebaseFirestoreServiceProvider)
            .firestore
            .collection(FirestoreCollections.debug_items)
            .withDebugItemConverter
            .orderBy(DebugItemKeys.createdAt, descending: false),
        startAfter: startAfter,
        limit: 10,
      ),
);
