import 'package:flutter/material.dart';

class ObscureToggleButton extends StatelessWidget {
  const ObscureToggleButton({super.key, required this.obscureText, required this.onPressed});

  final bool obscureText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
    );
  }
}