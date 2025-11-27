import 'dart:async';

import 'package:app/core/utils/future_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PaginatedList<T> {
  const factory PaginatedList({
    required List<T> items,
    required bool hasMore,
  }) = _PaginatedList<T>;

  const PaginatedList._({required this.items, required this.hasMore});

  final List<T> items;
  final bool hasMore;

  const factory PaginatedList.empty() = _PaginatedList<T>.empty;

  PaginatedList<R> updateItems<R>(R Function(int index, T item) cb);

  Future<PaginatedList<R>> updateItemsFuture<R>(
    Future<R> Function(int index, T item) cb,
  );

  PaginatedList<T> remove(int index);

  PaginatedList<T> append(PaginatedList<T> list);

  @override
  String toString() {
    return '''PaginatedList(items: $items)''';
  }
}

class _PaginatedList<T> extends PaginatedList<T> {
  const _PaginatedList({
    required super.items,
    required super.hasMore,
  }) : super._();

  const _PaginatedList.empty() : super._(items: const [], hasMore: false);

  @override
  PaginatedList<R> updateItems<R>(R Function(int index, T item) cb) {
    return _PaginatedList(
      items: items.indexed.map((e) => cb(e.$1, e.$2)).toList(),
      hasMore: hasMore,
    );
  }

  @override
  Future<PaginatedList<R>> updateItemsFuture<R>(
    Future<R> Function(int index, T item) cb,
  ) async {
    final updatedItems = await waitFuturesAndHoldOriginalOrder(
      items.indexed.map((e) => cb(e.$1, e.$2)).toList(),
    );
    return _PaginatedList(
      items: updatedItems,
      hasMore: hasMore,
    );
  }

  @override
  PaginatedList<T> remove(int index) {
    return _PaginatedList(
      items: [...items]..removeAt(index),
      hasMore: hasMore,
    );
  }

  @override
  PaginatedList<T> append(PaginatedList<T> list) {
    final allItems = [...items, ...list.items];

    /// 順序を保ちつつ重複を取り除く
    final seen = <T>{};
    final uniqueItems = <T>[];
    for (final item in allItems) {
      if (seen.add(item)) {
        uniqueItems.add(item);
      }
    }

    return _PaginatedList<T>(
      items: uniqueItems,
      hasMore: list.hasMore,
    );
  }
}

class CursouredPaginatedList<T> extends PaginatedList<T> {
  const CursouredPaginatedList({
    required this.page,
    required super.items,
    required super.hasMore,
  }) : super._();

  final int page;

  @override
  CursouredPaginatedList<T> append(covariant CursouredPaginatedList<T> list) {
    final allItems = [...items, ...list.items];

    /// 順序を保ちつつ重複を取り除く
    final seen = <T>{};
    final uniqueItems = <T>[];
    for (final item in allItems) {
      if (seen.add(item)) {
        uniqueItems.add(item);
      }
    }

    return CursouredPaginatedList<T>(
      page: list.page,
      items: uniqueItems,
      hasMore: list.hasMore,
    );
  }

  @override
  CursouredPaginatedList<T> remove(int index) {
    return CursouredPaginatedList(
      page: page,
      items: [...items]..removeAt(index),
      hasMore: hasMore,
    );
  }

  @override
  CursouredPaginatedList<R> updateItems<R>(R Function(int index, T item) cb) {
    // TODO: implement updateItems
    throw UnimplementedError();
  }

  @override
  Future<CursouredPaginatedList<R>> updateItemsFuture<R>(
    Future<R> Function(int index, T item) cb,
  ) {
    // TODO: implement updateItemsFuture
    throw UnimplementedError();
  }
}

typedef PaginatedListNotifierProvider<T> =
    AsyncNotifierProvider<
      PaginatedAsyncNotifier<T, PaginatedList<T>>,
      PaginatedList<T>
    >;

abstract class PaginatedAsyncNotifier<Item, T extends PaginatedList<Item>>
    extends AsyncNotifier<T> {
  Future<void> fetchMore();

  void remove(int index) {
    state = AsyncData(state.requireValue.remove(index) as T);
  }

  void updateItem(int index, Item newItem) {
    state = AsyncData(
      state.requireValue.updateItems(
            (currentIndex, item) => currentIndex == index ? newItem : item,
          )
          as T,
    );
  }
}
