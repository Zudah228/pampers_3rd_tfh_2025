import 'package:app/core/app/components/button/styles/styles.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends DefaultButton {
  const SecondaryButton({
    super.key,
    required this.child,
    required this.onPressed,
  }) : super(size: DefaultButtonSize.medium);

  const SecondaryButton.large({
    super.key,
    required this.child,
    required this.onPressed,
  }) : super(size: DefaultButtonSize.large);

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: size.minimumSize,
        textStyle: getDefaultTextStyle(context),
      ),
      child: child,
    );
  }
}
