import 'package:app/core/app/components/future/error.dart';
import 'package:app/core/app/components/future/loading_indicator.dart';
import 'package:app/core/app/components/refresh_indicator.dart';
import 'package:app/core/app/components/riverpod/async_value_switcher.dart';
import 'package:app/core/models/paginated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginatedListView<T> extends StatelessWidget {
  const PaginatedListView._({
    super.key,
    required this.builder,
    required this.onRefresh,
    required this.onLoading,
    required this.paginatedList,
  });

  final RefreshCallback onRefresh;
  final RefreshCallback onLoading;
  final PaginatedList<T> paginatedList;
  final Widget Function(List<T> items) builder;

  static Widget withAsyncNotifierProvider<T>({
    Key? key,
    required PaginatedListNotifierProvider<T> provider,
    required Widget Function(List<T> items) builder,
    RefreshCallback? onRefresh,
    Widget Function(Object, StackTrace)? onError,
    Widget? onLoading,
  }) {
    return Consumer(
      key: key,
      builder: (context, ref, child) {
        return AsyncValueSwitcher(
          asyncValue: ref.watch(provider),
          errorBuilder: (error, stackTrace) =>
              onError?.call(error, stackTrace) ??
              ErrorListView(error, stackTrace),
          loadingBuilder: () => onLoading ?? LoadingIndicator(),
          builder: (list) => PaginatedListView._(
            paginatedList: list,
            builder: builder,
            onRefresh: () async {
              await Future.wait([
                ref.refresh(provider.future),
                ?onRefresh?.call(),
              ]);
            },
            onLoading: () {
              return ref.read(provider.notifier).fetchMore();
            },
          ),
        );
      },
    );
  }

  static bool hasMore(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<_PaginatedListViewScope>()
            ?.hasMore ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final hasMore = paginatedList.hasMore;
    final items = paginatedList.items;

    return _PaginatedListViewScope(
      hasMore: hasMore,
      child: RefreshAndLoadingIndicator(
        onRefresh: onRefresh,
        onLoading: items.isNotEmpty && hasMore ? onLoading : null,
        child: builder(items),
      ),
    );
  }
}

class _PaginatedListViewScope extends InheritedWidget {
  const _PaginatedListViewScope({
    required super.child,
    required this.hasMore,
  });

  final bool hasMore;

  @override
  bool updateShouldNotify(covariant _PaginatedListViewScope oldWidget) {
    return hasMore != oldWidget.hasMore;
  }
}
