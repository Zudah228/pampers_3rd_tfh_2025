import 'package:app/core/app/components/layout/layout.dart';
import 'package:app/core/app/components/unfocused_gesture_detecter.dart';
import 'package:app/features/photo/components/add_photo.dart';
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

    return UnfocusedGestureDetecter(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (myRoom == null) ...[
                RoomCreateCard(),
                SizedBox(height: 48),
                RoomJoinCard(),
              ] else ...[
                Body(
                  children: [
                    AddPhoto(),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
