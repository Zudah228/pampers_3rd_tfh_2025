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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: _NavigationItem(
                  icon: Icons.home_outlined,
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemSelected(0),
                ),
              ),
              SizedBox(
                width: 48,
                height: 48,
                child: _NavigationItem(
                  icon: Icons.settings_outlined,
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemSelected(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final colorScheme = themeData.colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          width: isSelected ? 48 : 40,
          height: isSelected ? 48 : 40,
          child: AnimatedScale(
            scale: isSelected ? 1.0 : 0.9,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Container(
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary,
                        ],
                      )
                    : null,
                color: isSelected ? null : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colorScheme.primary,
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    icon,
                    key: ValueKey(isSelected),
                    color: isSelected
                        ? colorScheme.onPrimary
                        : AppColors.slateGray,
                    size: isSelected ? 22 : 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
