import 'package:app/features/user/models/user.dart';
import 'package:flutter/material.dart';

/// ユーザーアバターを表示するウィジェット
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.user,
    this.radius = 24,
    super.key,
  });

  final User? user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return CircleAvatar(
        radius: radius,
        child: Icon(Icons.person, size: radius),
      );
    }

    // アバター画像がある場合
    if (user!.avatarPath != null && user!.avatarPath!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(user!.avatarPath!),
      );
    }

    // アバター画像がない場合は名前の頭文字を表示
    final initial = user!.name?.isNotEmpty == true
        ? user!.name!.characters.first.toUpperCase()
        : '?';

    return CircleAvatar(
      radius: radius,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
