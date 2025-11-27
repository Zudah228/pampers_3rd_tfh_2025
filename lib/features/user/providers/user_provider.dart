import 'package:app/core/service/firebase_firestore/firebase_firestore_service.dart';
import 'package:app/core/service/firebase_firestore/models/firestore_collections.dart';
import 'package:app/core/utils/riverpod/firestore_provider.dart';
import 'package:app/features/auth/providers/current_user_provider.dart';
import 'package:app/features/user/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = FirestoreProvider.doc.create<User>(
  (ref, firestore) {
    final userId = ref.read(currentUserProvider).id;

    if (userId == null) {
      return null;
    }

    return firestore
        .collection(FirestoreCollections.users)
        .withUserConverter
        .doc(userId);
  },
);

extension UserWidgetRefExtension on WidgetRef {
  CollectionReference<User> get userCollectionReference => read(
    firebaseFirestoreServiceProvider,
  ).firestore.collection(FirestoreCollections.users).withUserConverter;

  DocumentReference<User> get currentUserDocumentReference =>
      userCollectionReference.doc(read(currentUserProvider).id!);
}
