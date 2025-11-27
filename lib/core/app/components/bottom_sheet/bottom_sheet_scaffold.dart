import 'package:flutter/material.dart';

class BottomSheetScaffold extends StatelessWidget {
  const BottomSheetScaffold({
    super.key,
    this.title,
    required this.child,
  });

  final Widget? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: .transparency,
      child: Column(
        mainAxisSize: .min,
        children: [
          if (title case final title?)
            Row(
              mainAxisAlignment: .spaceAround,
              children: [
                IgnorePointer(
                  child: Visibility.maintain(
                    visible: false,
                    child: CloseButton(),
                  ),
                ),
                Expanded(child: Center(child: title)),
                CloseButton(),
              ],
            )
          else
            SizedBox(height: 16),
          Flexible(child: child),
        ],
      ),
    );
  }
}
