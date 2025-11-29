import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/features/room/use_cases/join_room_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomJoinCard extends ConsumerStatefulWidget {
  const RoomJoinCard({super.key});
  @override
  ConsumerState<RoomJoinCard> createState() => _RoomJoinCardState();
}

class _RoomJoinCardState extends ConsumerState<RoomJoinCard> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'ルームIDを入力してください',
                ),
              ),
              SizedBox(height: 24),
              PrimaryButton(
                onPressed: () {
                  ref.read(joinRoomUseCaseProvider)(_controller.text);
                },
                child: Text('参加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
