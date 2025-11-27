import 'package:app/core/app/app.dart';
import 'package:app/core/app/app_state.dart';
import 'package:app/core/service/firebase/firebase_service.dart';
import 'package:app/core/service/package_info/package_info_service.dart';
import 'package:app/core/service/shared_preferences/shared_preferences_service.dart';
import 'package:app/core/utils/riverpod/riverpod_log_observer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'ja_JP';
  await initializeDateFormatting('ja');

  late final PackageInfoService packageInfoService;
  late final SharedPreferencesService sharedPreferencesService;

  await Future.wait([
    Future(() async {
      packageInfoService = await PackageInfoService.init();
    }),
    Future(() async {
      sharedPreferencesService = await SharedPreferencesService.init();
    }),
  ]);

  final container = ProviderContainer(
    retry: (retryCount, error) => null,
    observers: const [
      RiverpodLogObserver(),
    ],
    overrides: [
      packageInfoServiceProvider.overrideWithValue(packageInfoService),
      sharedPreferencesServiceProvider.overrideWithValue(
        sharedPreferencesService,
      ),
    ],
  );

  await container.read(firebaseServiceProvider).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: AppStateProvider(
        sharedPreferencesService: sharedPreferencesService,
        child: const MainApp(),
      ),
    ),
  );
}
