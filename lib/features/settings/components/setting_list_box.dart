import 'package:app/core/app/components/separator.dart';
import 'package:flutter/material.dart';

class SettingListBox extends StatelessWidget {
  const SettingListBox({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      decoration: ShapeDecoration(
        color: themeData.colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(8),
        ),
      ),
      clipBehavior: .antiAlias,
      child: Column(
        children: children.separatedWith(
          Divider(
            color: themeData.colorScheme.outlineVariant,
            height: 1,
          ),
        ),
      ),
    );
  }
}
