import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  const CommonDialog({
    super.key,
    this.title,
    required this.content,
    this.primaryAction,
    this.cancelAction,
    this.spaceBetweenTitleAndContent,
  });

  final Widget? title;
  final Widget? content;
  final double? spaceBetweenTitleAndContent;
  final CommonDialogAction? primaryAction;
  final CommonDialogAction? cancelAction;

  static Size get _actionMinimumSize => const Size(
    124,
    40,
  );
  static const _minDeviceSize = 375;

  Size _getActionMinimumSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth <= _minDeviceSize
        ? MediaQuery.of(context).size.width * 0.28
        : _actionMinimumSize.width;
    return Size(buttonWidth, _actionMinimumSize.height);
  }

  List<Widget> _getActions(BuildContext context) {
    final actionMinimumSize = _getActionMinimumSize(context);
    return [
      if (cancelAction case final action?)
        OutlinedButton(
          onPressed: action.onTap,
          style: OutlinedButton.styleFrom(
            minimumSize: actionMinimumSize,
          ),
          child: Text(action.label),
        ),
      if (primaryAction case final action?)
        FilledButton(
          onPressed: action.onTap,
          style: FilledButton.styleFrom(
            minimumSize: actionMinimumSize,
          ),
          child: Text(action.label),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    const defaultPadding = EdgeInsets.symmetric(horizontal: 24);

    final effectiveContentPadding =
        EdgeInsets.only(
          top: content == null
              ? 0
              : spaceBetweenTitleAndContent ??
                    (themeData.useMaterial3 ? 16.0 : 20.0),

          bottom: 24,
        ) +
        defaultPadding;

    final actions = _getActions(context);
    final MainAxisAlignment actionsAlignment = .end;

    return AlertDialog(
      title: title != null
          ? DefaultTextStyle.merge(
              child: title!,
            )
          : SizedBox(height: 16),
      titlePadding: title != null
          ? EdgeInsets.only(top: 16) + defaultPadding
          : .zero,
      titleTextStyle: content == null ? themeData.textTheme.titleMedium : null,
      contentPadding: effectiveContentPadding,
      content: content != null
          ? DefaultTextStyle.merge(
              child: content!,
            )
          : SizedBox.shrink(),

      actions: actions,
      actionsAlignment: actionsAlignment,
    );
  }
}

@immutable
class CommonDialogAction {
  const CommonDialogAction({required this.label, required this.onTap});

  final String label;

  /// Null を渡せば、ボタンが非活性になる
  final VoidCallback? onTap;
}
