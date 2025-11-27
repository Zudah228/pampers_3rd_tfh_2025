import 'package:flutter/material.dart';

class OverflowDivider extends StatelessWidget {
  const OverflowDivider({super.key, this.height, this.thickness, this.color});

  final double? height;
  final double? thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? DividerTheme.of(context).space ?? 16.0;

    return SizedBox(
      height: effectiveHeight,
      child: OverflowBox(
        maxHeight: effectiveHeight,
        maxWidth: MediaQuery.sizeOf(context).width,
        child: Divider(
          height: effectiveHeight,
          thickness: thickness,
          color: color,
        ),
      ),
    );
  }
}
