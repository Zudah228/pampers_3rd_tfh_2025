import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/features/home/providers/main_tab_provider.dart';
import 'package:app/features/settings/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  static Route<void> route() {
    return RouteAnimations.swipeBack<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainTab = ref.watch(mainTabProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(mainTab.label),
      ),
      body: IndexedStack(
        index: mainTab.index,
        children: [
          const Center(child: Text('HomePage')),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: (index) {
          ref.read(mainTabProvider.notifier).state = MainTab.values[index];
        },
        selectedIndex: mainTab.index,
      ),
    );
  }
}
