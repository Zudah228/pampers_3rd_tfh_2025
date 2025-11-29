import 'package:app/core/app/components/layout/layout.dart';
import 'package:app/features/room/components/room_card.dart';
import 'package:app/features/room/components/room_create_card.dart';
import 'package:app/features/room/components/room_join_card.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (myRoom == null) ...[
            Headline2(child: Text('ルームを作成')),
            Body(
              children: [
                RoomCreateCard(),
              ],
            ),
            Headline2(child: Text('ルームに参加')),
            Body(children: [RoomJoinCard()]),
          ] else
            RoomCard(room: myRoom),
        ],
      ),
    );
  }
}
