import 'package:app/core/app/components/bottom_sheet/selection_bottom_sheet.dart';
import 'package:flutter/material.dart';

Future<T?> showMenuModal<T>({
  required BuildContext context,
  required List<MenuEntry<T>> entries,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (context) => _MenuModal<T>(entries: entries),
  );
}

@immutable
class MenuEntry<T> {
  const MenuEntry({this.icon, required this.child, required this.value});

  final Widget? icon;
  final Widget child;
  final T value;
}

class _MenuModal<T> extends StatelessWidget {
  const _MenuModal({super.key, required this.entries});

  final List<MenuEntry<T>> entries;

  @override
  Widget build(BuildContext context) {
    return SelectionBottomSheet(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];

        return ListTile(
          leading: entry.icon,
          title: entry.child,
          onTap: () {
            Navigator.of(context).pop(entry.value);
          },
        );
      },
    );
  }
}
