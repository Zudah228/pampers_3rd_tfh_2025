import 'package:app/core/app/theme/app_colors.dart';
import 'package:app/core/app/theme/expanded_color_scheme.dart';
import 'package:app/core/app/theme/text_theme.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

abstract final class AppThemeData {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.sunsetGold,
      onPrimary: AppColors.white,
      onSurface: AppColors.slateGray,
      onSurfaceVariant: AppColors.charcoal,
      primaryContainer: AppColors.lightSand,
      onPrimaryContainer: AppColors.charcoal,
      onPrimaryFixed: AppColors.charcoal,
      secondary: AppColors.softDenim,
      onSecondary: AppColors.slateGray,
      onSecondaryContainer: AppColors.charcoal,
      surface: AppColors.cream,
      surfaceContainer: AppColors.white,
      error: AppColors.sunsetRose,
      outline: AppColors.lightBeige,
      outlineVariant: AppColors.warmGray,
    );

    return _base(colorScheme);
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.sunsetGold,
      secondary: AppColors.softDenim,
      error: AppColors.sunsetRose,
      brightness: Brightness.dark,
    );
    return _base(colorScheme);
  }

  static ThemeData _base(ColorScheme colorScheme) {
    final foundation = ThemeData(
      colorScheme: colorScheme,
      fontFamily: defaultFontFamily,
      extensions: [ExpandedColorScheme()],
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
        color: colorScheme.surface,
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
        fillColor: colorScheme.surfaceContainer,
        hintStyle: TextStyle(color: colorScheme.outlineVariant),
        enabledBorder: inputBorder(
          BorderSide(color: colorScheme.outlineVariant, width: 2),
        ),
        focusedBorder: inputBorder(
          BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: inputBorder(
          BorderSide(color: colorScheme.error, width: 2),
        ),
        focusedErrorBorder: inputBorder(
          BorderSide(color: colorScheme.error, width: 2),
        ),
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
        subtitleTextStyle: TextStyle(
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
