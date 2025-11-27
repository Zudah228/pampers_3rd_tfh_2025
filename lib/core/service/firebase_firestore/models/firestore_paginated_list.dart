import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/core/models/paginated_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/providers/async_notifier.dart'
    show AsyncNotifierProviderFamily;

typedef FirestorePaginatedList<T> = PaginatedList<FirestoreDocument<T>>;
typedef FirestorePaginatedListNotifierProvider<T> =
    AsyncNotifierProvider<
      FirestorePaginatedListNotifier<T>,
      PaginatedList<FirestoreDocument<T>>
    >;

abstract final class FirestorePaginatedListNotifierProviderBuilder {
  const FirestorePaginatedListNotifierProviderBuilder._();

  static AsyncNotifierProvider<
    FirestorePaginatedListNotifier<T>,
    PaginatedList<FirestoreDocument<T>>
  >
  create<T>(
    FirestorePaginatedListNotifierBuilder<T> fetch, {
    bool isAutoDispose = true,
  }) {
    return AsyncNotifierProvider(
      () => FirestorePaginatedListNotifier.create<T>(fetch),
      isAutoDispose: isAutoDispose,
    );
  }

  static AsyncNotifierProviderFamily<
    FirestorePaginatedListNotifier<T>,
    PaginatedList<FirestoreDocument<T>>,
    Arg
  >
  family<T, Arg>(
    FirestorePaginatedListNotifierFamilyBuilder<T, Arg> fetch, {
    bool isAutoDispose = true,
  }) {
    return AsyncNotifierProvider.family<
      FirestorePaginatedListNotifier<T>,
      PaginatedList<FirestoreDocument<T>>,
      Arg
    >(
      (Arg arg) => FirestorePaginatedListNotifier.create<T>(
        (ref, startAfter) => fetch(ref, arg, startAfter),
      ),
      isAutoDispose: isAutoDispose,
    );
  }
}

@immutable
class FirestoreDocument<T> {
  const FirestoreDocument({
    required this.data,
    required this.snapshot,
  });

  final DocumentSnapshot snapshot;
  final T data;

  FirestoreDocument<R> copyWith<R>({
    required R data,
  }) {
    return FirestoreDocument(
      snapshot: snapshot,
      data: data,
    );
  }
}

typedef FirestorePaginatedListNotifierBuilder<T> =
    Future<FirestorePaginatedList<T>> Function(Ref ref, Object? startAfter);
typedef FirestorePaginatedListNotifierFamilyBuilder<T, Arg> =
    Future<FirestorePaginatedList<T>> Function(
      Ref ref,
      Arg arg,
      Object? startAfter,
    );

abstract class FirestorePaginatedListNotifier<T>
    extends
        PaginatedAsyncNotifier<
          FirestoreDocument<T>,
          FirestorePaginatedList<T>
        > {
  static FirestorePaginatedListNotifier<T> create<T>(
    FirestorePaginatedListNotifierBuilder<T> fetch,
  ) {
    return _CustomFirestorePaginatedListNotifier(fetch);
  }

  @override
  FutureOr<FirestorePaginatedList<T>> build() {
    return fetch();
  }

  Future<FirestorePaginatedList<T>> fetch([Object? startAfter]);

  @override
  Future<void> fetchMore() async {
    final current = state.requireValue;
    final ret = await fetch(current.items.lastOrNull?.snapshot);

    state = AsyncData(state.requireValue.append(ret));
  }
}

class _CustomFirestorePaginatedListNotifier<T>
    extends FirestorePaginatedListNotifier<T> {
  _CustomFirestorePaginatedListNotifier(this._fetchCallback);

  final FirestorePaginatedListNotifierBuilder<T> _fetchCallback;

  @override
  Future<FirestorePaginatedList<T>> fetch([Object? startAfter]) {
    return _fetchCallback(ref, startAfter);
  }
}
