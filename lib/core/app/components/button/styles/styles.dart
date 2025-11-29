import 'package:flutter/material.dart';

const Size buttonLargeSize = Size(double.infinity, 64);

enum DefaultButtonSize {
  large,
  medium
  ;

  Size get minimumSize {
    switch (this) {
      case DefaultButtonSize.large:
        return Size(double.infinity, 56);
      case DefaultButtonSize.medium:
        return Size(0, 48);
    }
  }
}

abstract class DefaultButton extends StatelessWidget {
  const DefaultButton({super.key, required this.size});

  final DefaultButtonSize size;

  TextStyle getDefaultTextStyle(BuildContext context) => switch (size) {
    DefaultButtonSize.large => Theme.of(context).textTheme.titleMedium!,
    DefaultButtonSize.medium => Theme.of(context).textTheme.titleSmall!,
  };
}
