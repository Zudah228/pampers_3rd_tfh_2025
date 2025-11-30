import 'package:app/core/app/components/custom_app_bar.dart';
import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/core/app/theme/app_colors.dart';
import 'package:app/features/home/pages/home_page.dart';
import 'package:app/features/home/providers/main_tab_provider.dart';
import 'package:app/features/room/providers/my_room_provider.dart';
import 'package:app/features/room/providers/room_members_provider.dart';
import 'package:app/features/settings/pages/settings_page.dart';
import 'package:app/features/user/components/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageShell extends ConsumerWidget {
  const HomePageShell({super.key});

  static const routeName = '/home';

  static Route<void> route() {
    return RouteAnimations.swipeBack<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const HomePageShell(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainTab = ref.watch(mainTabProvider);
    final myRoom = ref.watch(myRoomProvider).value;
    final currentUser = ref.watch(currentUserInfoProvider).value;
    final partnerUser = ref.watch(partnerUserProvider).value;

    return Scaffold(
      appBar: myRoom == null || mainTab == MainTab.settings
          ? AppBar(title: Text(mainTab.label))
          : CustomAppBar(
              title: myRoom.name ?? 'ルーム名読み込み中',
              child: Row(
                children: [
                  // 自分のアバターを表示
                  UserAvatar(
                    user: currentUser,
                    radius: 24,
                  ),
                  SizedBox(width: 4),
                  // パートナーのアバターを表示
                  UserAvatar(
                    user: partnerUser,
                    radius: 24,
                  ),
                ],
              ),
            ),

      body: IndexedStack(
        index: mainTab.index,
        children: [
          const HomePage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: _CustomBottomNavigationBar(
        selectedIndex: mainTab.index,
        onItemSelected: (index) {
          ref.read(mainTabProvider.notifier).state = MainTab.values[index];
        },
      ),
    );
  }
}

class _CustomBottomNavigationBar extends StatelessWidget {
  const _CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final colorScheme = themeData.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavigationItem(
            icon: Icons.home_outlined,
            label: 'ホーム',
            isSelected: selectedIndex == 0,
            onTap: () => onItemSelected(0),
          ),
          _NavigationItem(
            icon: Icons.settings_outlined,
            label: '設定',
            isSelected: selectedIndex == 1,
            onTap: () => onItemSelected(1),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final colorScheme = themeData.colorScheme;

    if (isSelected) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Positioned(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Icon(
                    icon,
                    color: colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.only(top: 16),
          child: SizedBox(
            width: 48,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: AppColors.slateGray,
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.slateGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
