import 'package:app/core/app/app_state.dart';
import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/core/service/firebase_auth/firebase_auth_service.dart';
import 'package:app/core/service/package_info/package_info_service.dart';
import 'package:app/features/auth/models/current_user.dart';
import 'package:app/features/auth/pages/sign_in_page.dart';
import 'package:app/features/auth/providers/current_user_provider.dart';
import 'package:app/features/debug/debug_page.dart';
import 'package:app/features/settings/components/setting_list_box.dart';
import 'package:app/features/user/pages/user_settings_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfoService = ref.watch(packageInfoServiceProvider);
    final isAuthenticated = ref.watch(currentUserProvider) is AuthenticatedUser;

    return SingleChildScrollView(
      padding: const .symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 16),
          SettingListBox(
            children: [
              _ThemeModeButton(),
              if (isAuthenticated)
                _ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('ユーザー設定'),
                  onTap: () {
                    Navigator.of(context).push(UserSettingsPage.route());
                  },
                ),
              _ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('ライセンス'),
                onTap: () {
                  LicenseRegistry.addLicense(() async* {
                    final String license = await rootBundle.loadString(
                      'assets/fonts/Noto_Sans_JP/OFL.txt',
                    );
                    yield LicenseEntryWithLineBreaks(<String>[
                      'google_fonts',
                    ], license);
                  });
                  Navigator.of(context).push(
                    RouteAnimations.noAnimation<void>(
                      settings: const RouteSettings(name: '/license'),
                      builder: (_) => const LicensePage(),
                    ),
                  );
                },
              ),
              _ListTile(
                leading: const Icon(Icons.bug_report),
                title: const Text('デバッグ'),
                onTap: () {
                  Navigator.of(context).push(DebugPage.route());
                },
              ),
              if (isAuthenticated)
                _ListTile(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  leading: Icon(Icons.exit_to_app),
                  title: Text('ログアウト'),
                  onTap: () {
                    ref.read(firebaseAuthServiceProvider).signOut();
                  },
                )
              else
                _ListTile(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  leading: const Icon(Icons.login),
                  title: Text('ログイン'),
                  onTap: () {
                    Navigator.of(context).push(SignInPage.route());
                  },
                ),
            ],
          ),
          SizedBox(height: 16),
          Text('バージョン ${packageInfoService.version}'),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.title,
    required this.onTap,
    this.foregroundColor,
    this.leading,
    this.subtitle,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Color? foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        minVerticalPadding: 8,
        title: title,
        titleTextStyle: TextStyle(
          color: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
        ),
        leading: leading != null
            ? IconTheme.merge(
                data: IconThemeData(color: foregroundColor),
                child: leading!,
              )
            : null,
        subtitle: subtitle,
        onTap: onTap,
      ),
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton();

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);

    return PopupMenuButton<ThemeMode>(
      position: PopupMenuPosition.under,
      initialValue: appState.themeMode,
      tooltip: 'テーマを変更します',
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeMode.light,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              Icon(Icons.light_mode),
              Text('ライトモード'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              Icon(Icons.dark_mode),
              Text('ダークモード'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              Icon(Icons.monitor),
              Text('システム'),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        appState.updateThemeMode(value);
      },
      child: Builder(
        builder: (context) {
          return _ListTile(
            leading: Icon(switch (Theme.of(context).brightness) {
              Brightness.light => Icons.light_mode,
              Brightness.dark => Icons.dark_mode,
            }),
            title: const Text('テーマ'),
            subtitle: Text(switch (appState.themeMode) {
              ThemeMode.light => 'ライトモード',
              ThemeMode.dark => 'ダークモード',
              ThemeMode.system => 'システムに従っています',
            }),
            onTap: () {
              context
                  .findAncestorStateOfType<PopupMenuButtonState<ThemeMode>>()
                  ?.showButtonMenu();
            },
          );
        },
      ),
    );
  }
}
