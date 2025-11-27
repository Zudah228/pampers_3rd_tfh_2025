import 'package:app/core/app/components/dialog/dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  Widget? title,
  Widget? content,
  String? cancelLabel,
  bool showChancelButton = true,
  String okLabel = 'OK',
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (_) => _CommonConfirmDialog(
      title: title,
      content: content,
      cancelLabel: cancelLabel,
      okLabel: okLabel,
      showChancelButton: showChancelButton,
    ),
  ).then(
    (value) => value ?? false,
  );
}

class _CommonConfirmDialog extends StatelessWidget {
  const _CommonConfirmDialog({
    required this.title,
    required this.content,
    required this.cancelLabel,
    required this.okLabel,
    required this.showChancelButton,
  });

  final Widget? title;
  final Widget? content;
  final String? cancelLabel;
  final String okLabel;
  final bool showChancelButton;

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: title,
      content: content,
      cancelAction: showChancelButton
          ? CommonDialogAction(
              label: cancelLabel ?? 'キャンセル',
              onTap: () {
                Navigator.of(context).pop(false);
              },
            )
          : null,
      primaryAction: CommonDialogAction(
        label: okLabel,
        onTap: () {
          Navigator.of(context).pop(true);
        },
      ),
    );
  }
}
