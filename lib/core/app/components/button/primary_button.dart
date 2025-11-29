import 'package:app/core/app/components/button/styles/styles.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends DefaultButton {
  const PrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(size: DefaultButtonSize.medium);

  const PrimaryButton.large({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(size: DefaultButtonSize.large);

  const PrimaryButton.small({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(size: DefaultButtonSize.small);

  const PrimaryButton.custom({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    required super.size,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: size.minimumSize,
        textStyle: getDefaultTextStyle(context),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
