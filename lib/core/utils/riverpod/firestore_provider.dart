import 'package:app/core/models/paginated_list.dart';
import 'package:app/core/service/firebase_firestore/firebase_firestore_service.dart';
import 'package:app/core/service/firebase_firestore/models/firestore_paginated_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/providers/async_notifier.dart'
    show AsyncNotifierProviderFamily;
import 'package:riverpod/src/providers/future_provider.dart'
    show FutureProviderFamily;
import 'package:riverpod/src/providers/stream_provider.dart'
    show StreamProviderFamily;

abstract final class FirestoreProvider {
  const FirestoreProvider._();

  static const doc = FirestoreDocumentProviderBuilder._();

  static const page = FirestorePageProviderBuilder._();

  static const query = FirestoreCountProviderBuilder._();
}

final class FirestoreCountProviderBuilder {
  const FirestoreCountProviderBuilder._();

  FutureProvider<int> create(
    Query Function(Ref ref, FirebaseFirestore firestore) query,
  ) => FutureProvider.autoDispose<int>(
    (ref) => query(
      ref,
      ref.watch(firebaseFirestoreServiceProvider).firestore,
    ).count().get().then((value) => value.count ?? 0),
  );

  FutureProviderFamily<int, Arg> family<Arg>(
    Query Function(Ref ref, FirebaseFirestore firestore) query,
  ) => FutureProvider.autoDispose.family<int, Arg>(
    (ref, arg) => query(
      ref,
      ref.watch(firebaseFirestoreServiceProvider).firestore,
    ).count().get().then((value) => value.count ?? 0),
  );
}

final class FirestoreDocumentProviderBuilder {
  const FirestoreDocumentProviderBuilder._();

  StreamProvider<T?> create<T>(
    DocumentReference<T>? Function(Ref ref, FirebaseFirestore firestore)
    referenceBuilder,
  ) => StreamProvider.autoDispose<T?>(
    (ref) {
      final reference = referenceBuilder(
        ref,
        ref.watch(firebaseFirestoreServiceProvider).firestore,
      );

      if (reference == null) {
        return Stream.value(null);
      }

      return reference.snapshots().map((snapshot) => snapshot.data());
    },
  );

  StreamProviderFamily<T?, Arg> family<T, Arg>(
    DocumentReference<T>? Function(Ref ref, FirebaseFirestore firestore)
    referenceBuilder,
  ) => StreamProvider.autoDispose.family<T?, Arg>(
    (ref, arg) {
      final reference = referenceBuilder(
        ref,
        ref.watch(firebaseFirestoreServiceProvider).firestore,
      );

      if (reference == null) {
        return Stream.value(null);
      }

      return reference.snapshots().map((snapshot) => snapshot.data());
    },
  );
}

final class FirestorePageProviderBuilder {
  const FirestorePageProviderBuilder._();

  AsyncNotifierProvider<
    FirestorePaginatedListNotifier<T>,
    PaginatedList<FirestoreDocument<T>>
  >
  create<T>(
    FirestorePaginatedListNotifierBuilder<T> fetch, {
    bool isAutoDispose = true,
  }) {
    return FirestorePaginatedListNotifierProviderBuilder.create(
      fetch,
      isAutoDispose: isAutoDispose,
    );
  }

  AsyncNotifierProviderFamily<
    FirestorePaginatedListNotifier<T>,
    PaginatedList<FirestoreDocument<T>>,
    Arg
  >
  family<T, Arg>(
    FirestorePaginatedListNotifierFamilyBuilder<T, Arg> fetch, {
    bool isAutoDispose = true,
  }) {
    return FirestorePaginatedListNotifierProviderBuilder.family(
      fetch,
      isAutoDispose: isAutoDispose,
    );
  }
}
