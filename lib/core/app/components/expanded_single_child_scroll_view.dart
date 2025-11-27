import 'package:flutter/material.dart';

class ExpandedSingleChildScrollView extends StatelessWidget {
  const ExpandedSingleChildScrollView({
    super.key,
    required this.child,
    this.padding,
    this.primary,
    this.controller,
  });

  final ScrollController? controller;
  final bool? primary;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: padding,
          primary: primary,
          controller: controller,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        );
      },
    );
  }
}
