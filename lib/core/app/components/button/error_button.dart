import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/button/styles/styles.dart';
import 'package:flutter/material.dart';

class ErrorButton extends DefaultButton {
  const ErrorButton({
    super.key,
    required this.child,
    required this.onPressed,
  }) : super(size: DefaultButtonSize.medium);

  const ErrorButton.large({
    super.key,
    required this.child,
    required this.onPressed,
  }) : super(size: DefaultButtonSize.large);

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton.custom(
      size: size,
      backgroundColor: Theme.of(context).colorScheme.error,
      foregroundColor: Theme.of(context).colorScheme.onError,
      onPressed: onPressed,
      child: child,
    );
  }
}
