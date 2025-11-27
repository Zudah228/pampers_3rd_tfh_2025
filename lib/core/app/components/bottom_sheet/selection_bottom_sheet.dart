import 'package:app/core/app/components/bottom_sheet/bottom_sheet_scaffold.dart';
import 'package:flutter/material.dart';

class SelectionBottomSheet extends StatelessWidget {
  const SelectionBottomSheet({
    super.key,
    this.title,
    required this.itemBuilder,
    required this.itemCount,
  });

  final Widget? title;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return BottomSheetScaffold(
      title: title,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: .min,
          children: [
            for (var i = 0; i < itemCount; i++) itemBuilder(context, i),
            Divider(height: 16),
            ListTile(
              title: Center(child: Text('閉じる')),
              onTap: () {
                Navigator.of(context).pop();
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16) +
                  EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
            ),
          ],
        ),
      ),
    );
  }
}
