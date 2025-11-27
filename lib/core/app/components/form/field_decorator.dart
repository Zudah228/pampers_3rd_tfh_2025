import 'package:app/core/app/components/form/required_label.dart';
import 'package:flutter/material.dart';

class FieldDecorator extends StatelessWidget {
  const FieldDecorator({
    super.key,
    required this.child,
    this.label,
    this.showRequiredLabel = false,
  });

  final Widget? label;
  final bool showRequiredLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    ValueListenableBuilder(
      valueListenable: TextEditingController(),
      builder: (context, value, _) {
        return Text(value.text);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          DefaultTextStyle.merge(
            style: themeData.textTheme.titleMedium,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                label!,
                SizedBox(width: 8),
                if (showRequiredLabel) const RequiredLabel(),
              ],
            ),
          ),
        SizedBox(height: 8),
        child,
      ],
    );
  }
}
