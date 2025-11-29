import 'package:app/core/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ExpandedColorScheme extends ThemeExtension<ExpandedColorScheme> {
  const ExpandedColorScheme({this.green = AppColors.softSage});

  final Color green;

  factory ExpandedColorScheme.of(BuildContext context) {
    final data = Theme.of(context).extension<ExpandedColorScheme>();

    if (data == null) {
      throw UnsupportedError('ExpandedColorScheme が extensions に設定されていません。');
    }

    return data;
  }

  @override
  ThemeExtension<ExpandedColorScheme> copyWith({Color? green}) {
    return ExpandedColorScheme(green: green ?? this.green);
  }

  @override
  ThemeExtension<ExpandedColorScheme> lerp(
    covariant ExpandedColorScheme? other,
    double t,
  ) {
    return ExpandedColorScheme(
      green: Color.lerp(green, other?.green, t) ?? green,
    );
  }
}
