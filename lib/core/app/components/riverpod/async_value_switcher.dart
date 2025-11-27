import 'package:app/core/app/components/future/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class AsyncValueSwitcher<T> extends StatelessWidget {
  const AsyncValueSwitcher({
    super.key,
    required this.asyncValue,
    required this.builder,
    required this.errorBuilder,
    this.loadingBuilder,
    this.skipLoadingOnReload = false,
    this.skipLoadingOnRefresh = false,
    this.skipError = false,
    this.duration = Durations.short3,
  });

  final AsyncValue<T> asyncValue;
  final Widget Function(T value) builder;
  final Widget Function(Object error, StackTrace stackTrace) errorBuilder;
  final Widget Function()? loadingBuilder;
  final bool skipLoadingOnReload;
  final bool skipLoadingOnRefresh;
  final bool skipError;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      child: asyncValue.when(
        skipLoadingOnReload: skipLoadingOnReload,
        skipLoadingOnRefresh: skipLoadingOnRefresh,
        skipError: skipError,
        data: builder,
        error: errorBuilder,
        loading: loadingBuilder ?? () => const LoadingIndicator(),
      ),
    );
  }
}
