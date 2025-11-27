import 'package:app/core/app/components/future/loading_indicator.dart';
import 'package:flutter/material.dart';

class FutureSwitcher<T> extends StatefulWidget {
  const FutureSwitcher({
    super.key,
    required this.fetch,
    required this.builder,
    required this.errorBuilder,
    this.loadingBuilder,
  });

  factory FutureSwitcher.dataOrNull({
    Key? key,
    required Future<T> Function() fetch,
    required Widget Function(T? data) builder,
    Widget Function()? loadingBuilder,
  }) {
    return FutureSwitcher(
      key: key,
      fetch: fetch,
      builder: builder,
      loadingBuilder: loadingBuilder ?? () => builder(null),
      errorBuilder: (error, stackTrace) {
        return builder(null);
      },
    );
  }

  final Future<T> Function() fetch;
  final Widget Function()? loadingBuilder;
  final Widget Function(T data) builder;
  final Widget Function(Object? error, StackTrace? stackTrace) errorBuilder;

  @override
  State<FutureSwitcher<T>> createState() => _FutureSwitcherState<T>();
}

class _FutureSwitcherState<T> extends State<FutureSwitcher<T>> {
  Future<T?>? _future;

  @override
  void initState() {
    super.initState();
    _future = widget.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T?>(
      future: _future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return widget.loadingBuilder?.call() ?? const LoadingIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return widget.errorBuilder(snapshot.error, snapshot.stackTrace);
            }
            return widget.builder(snapshot.data as T);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
