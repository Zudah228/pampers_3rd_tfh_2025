import 'package:app/core/app/theme/app_colors.dart';
import 'package:app/core/app/theme/expanded_color_scheme.dart';
import 'package:app/core/app/theme/text_theme.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

abstract final class AppThemeData {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.sunsetGold,
      primary: AppColors.sunsetGold,
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

    final buttonStyleButtonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        SmoothRadius(cornerRadius: 14, cornerSmoothing: 0.2),
      ),
    );

    return foundation.copyWith(
      cardTheme: CardThemeData(
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surfaceContainer,
      ),
      textTheme: foundation.textTheme
          .apply(
            bodyColor: colorScheme.onSurface,
            displayColor: colorScheme.onSurface,
          )
          .copyWith(
            titleLarge: foundation.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
            titleMedium: foundation.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: buttonStyleButtonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: buttonStyleButtonShape),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: buttonStyleButtonShape,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.2),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showUnselectedLabels: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainer,
        hintStyle: TextStyle(color: colorScheme.outlineVariant),
        enabledBorder: inputBorder(
          BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: inputBorder(
          BorderSide(color: colorScheme.primary),
        ),
        errorBorder: inputBorder(
          BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: inputBorder(
          BorderSide(color: colorScheme.error),
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
