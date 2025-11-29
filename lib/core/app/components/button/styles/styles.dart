import 'package:flutter/material.dart';

const Size buttonLargeSize = Size(double.infinity, 64);

enum DefaultButtonSize {
  large,
  small,
  medium
  ;

  Size get minimumSize {
    switch (this) {
      case DefaultButtonSize.large:
        return Size(double.infinity, 56);
      case DefaultButtonSize.medium:
        return Size(0, 48);
      case DefaultButtonSize.small:
        return Size(0, 32);
    }
  }
}

abstract class DefaultButton extends StatelessWidget {
  const DefaultButton({super.key, required this.size});

  final DefaultButtonSize size;

  TextStyle getDefaultTextStyle(BuildContext context) => switch (size) {
    DefaultButtonSize.large => Theme.of(context).textTheme.titleMedium!,
    DefaultButtonSize.small => Theme.of(context).textTheme.bodyMedium!,
    DefaultButtonSize.medium => Theme.of(context).textTheme.titleSmall!,
  };
}
