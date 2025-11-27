import 'package:app/core/app/components/snack_bar.dart';
import 'package:app/core/utils/logger.dart';
import 'package:flutter/material.dart';

/// 全画面のローディング
/// ref: https://zenn.dev/zudah228/articles/84d20cf5ff73f8
class FullScreenLoadingIndicator extends StatefulWidget {
  const FullScreenLoadingIndicator({super.key});

  static Future<void> show(Future<void> Function() cb) async {
    if (_state == null || !_state!.mounted) {
      logger.error(
        'LoadingIndicator.show() was called \n'
        'No State of LoadingIndicator widget has created.',
        error: Exception('No State of LoadingIndicator widget has created.'),
        stackTrace: StackTrace.current,
      );
    }
    await _state!._show(cb);
  }

  static Widget wrap(Widget child) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        const Positioned.fill(child: FullScreenLoadingIndicator()),
      ],
    );
  }

  static late _FullScreenLoadingIndicatorState? _state;

  @override
  State<FullScreenLoadingIndicator> createState() =>
      _FullScreenLoadingIndicatorState();
}

class _FullScreenLoadingIndicatorState
    extends State<FullScreenLoadingIndicator> {
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(false);

  Future<void> _show(Future<void> Function() cb) async {
    _isLoadingNotifier.value = true;

    try {
      await cb();
    } on Exception catch (error, stackTrace) {
      logger.error('', error: error, stackTrace: stackTrace);

      showErrorSnackBar(message: 'エラーが発生しました');
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  @override
  void didChangeDependencies() {
    FullScreenLoadingIndicator._state = this;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    FullScreenLoadingIndicator._state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isLoadingNotifier,
      builder: (context, value, child) {
        return Visibility(visible: value, child: child!);
      },
      child: SizedBox.expand(
        child: ColoredBox(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerLow.withAlpha(40),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
