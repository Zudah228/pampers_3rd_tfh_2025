import 'package:app/core/service/shared_preferences/shared_preferences_key.dart';
import 'package:app/core/service/shared_preferences/shared_preferences_service.dart';
import 'package:flutter/material.dart';

abstract class AppState {
  const AppState({
    required this.themeMode,
  });

  final ThemeMode themeMode;
  void updateThemeMode(ThemeMode themeMode);

  static AppState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AppStateScope>()!
        .appState;
  }
}

class AppStateProvider extends StatefulWidget {
  const AppStateProvider({
    super.key,
    required this.sharedPreferencesService,
    required this.child,
  });

  final SharedPreferencesService? sharedPreferencesService;
  final Widget child;

  @override
  State<AppStateProvider> createState() => _AppStateProviderState();
}

class _AppStateProviderState extends State<AppStateProvider>
    implements AppState {
  SharedPreferencesService? get _sharedPreferencesService =>
      widget.sharedPreferencesService;

  int _generation = 0;

  late ThemeMode _themeMode;

  @override
  ThemeMode get themeMode => _themeMode;

  @override
  void updateThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      _generation++;
    });
    _sharedPreferencesService?.save(
      SharedPreferencesKey.theme_mode,
      themeMode,
    );
  }

  @override
  void initState() {
    super.initState();

    final themeModeString = _sharedPreferencesService?.fetch<String>(
      SharedPreferencesKey.theme_mode,
    );
    _themeMode = themeModeString != null
        ? ThemeMode.values.byName(themeModeString)
        : ThemeMode.system;
  }

  @override
  Widget build(BuildContext context) {
    return _AppStateScope(
      appState: this,
      generation: _generation,
      child: widget.child,
    );
  }
}

class _AppStateScope extends InheritedWidget {
  const _AppStateScope({
    required this.appState,
    required this.generation,
    required super.child,
  });

  final AppState appState;
  final int generation;

  @override
  bool updateShouldNotify(_AppStateScope oldWidget) {
    return oldWidget.generation != generation;
  }
}
