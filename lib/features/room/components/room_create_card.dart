import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/features/room/use_cases/create_room_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomCreateCard extends ConsumerWidget {
  const RoomCreateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: PrimaryButton(
            onPressed: () {
              FullScreenLoadingIndicator.show(() async {
                await ref.read(createRoomUseCaseProvider)();
              });
            },
            child: Text('作成'),
          ),
        ),
      ),
    );
  }
}
