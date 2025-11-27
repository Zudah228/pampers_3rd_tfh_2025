import 'package:flutter/material.dart';

class RequiredLabel extends StatelessWidget {
  const RequiredLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Text(
      '必須',
      style: themeData.textTheme.labelMedium!.copyWith(
        color: themeData.colorScheme.secondary,
      ),
    );
  }
}
