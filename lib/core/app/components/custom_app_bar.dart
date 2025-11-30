import 'package:app/core/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.child,
    this.isBackButton = false,
  });

  final String title;
  final Widget? child;
  final bool isBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      toolbarHeight: 80,
      leading: Padding(
        padding: isBackButton
            ? const EdgeInsets.only(left: 16)
            : EdgeInsets.zero,
        child: Center(
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: isBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
      title: Row(
        children: [
          if (child != null) ...[
            child!,
            const SizedBox(width: 24),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
