import 'package:app/features/room/components/my_room_card.dart';
import 'package:app/features/room/components/room_create_card.dart';
import 'package:app/features/room/providers/my_room_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ホームページへの遷移は、HomePageShell を使用
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRoom = ref.watch(myRoomProvider).value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (myRoom == null) RoomCreateCard() else MyRoomCard(room: myRoom),
        ],
      ),
    );
  }
}
