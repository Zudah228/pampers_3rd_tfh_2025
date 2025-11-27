import 'package:app/core/app/app_state.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/app/theme/theme.dart';
import 'package:app/core/app/global_keys.dart';
import 'package:app/features/home/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);

    return MaterialApp(
      themeMode: appState.themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      theme: AppThemeData.light,
      darkTheme: AppThemeData.dark,
      navigatorKey: globalNavigatorKey,
      scaffoldMessengerKey: globalScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => FullScreenLoadingIndicator.wrap(child!),
      home: const HomePage(),
    );
  }
}
