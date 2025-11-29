import 'package:app/core/app/components/button/styles/styles.dart';
import 'package:flutter/material.dart';

class TertiaryButton extends DefaultButton {
  const TertiaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.foregroundColor,
  }) : super(size: DefaultButtonSize.medium);

  const TertiaryButton.large({
    super.key,
    required this.child,
    required this.onPressed,
    this.foregroundColor,
  }) : super(size: DefaultButtonSize.large);

  const TertiaryButton.small({
    super.key,
    required this.child,
    required this.onPressed,
    this.foregroundColor,
  }) : super(size: DefaultButtonSize.small);

  final Widget child;
  final Color? foregroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: size.minimumSize,
        textStyle: getDefaultTextStyle(context),
        foregroundColor: foregroundColor,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
