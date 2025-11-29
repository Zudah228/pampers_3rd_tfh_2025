import 'package:app/core/app/theme/app_colors.dart';
import 'package:app/core/app/theme/text_theme.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

abstract final class AppThemeData {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);

    return _base(colorScheme);
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    );
    return _base(colorScheme);
  }

  static ThemeData _base(ColorScheme colorScheme) {
    final foundation = ThemeData(
      colorScheme: colorScheme,
      fontFamily: defaultFontFamily,
    );

    InputBorder inputBorder(BorderSide borderSide) => OutlineInputBorder(
      borderRadius: BorderRadius.all(
        SmoothRadius(cornerRadius: 8, cornerSmoothing: 0.2),
      ),
      borderSide: borderSide,
    );

    return foundation.copyWith(
      cardTheme: CardThemeData(
        clipBehavior: Clip.antiAlias,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.2),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cream,
        enabledBorder: inputBorder(BorderSide(color: AppColors.warmGray)),
        focusedBorder: inputBorder(BorderSide(color: AppColors.sunsetGold)),
        errorBorder: inputBorder(BorderSide(color: AppColors.warmGray)),
        focusedErrorBorder: inputBorder(
          BorderSide(color: AppColors.sunsetRose),
        ),
      ),
    );
  }
}
