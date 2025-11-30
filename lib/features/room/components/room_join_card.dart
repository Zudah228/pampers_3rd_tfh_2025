import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/form/field_decorator.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/app/components/layout/layout.dart';
import 'package:app/core/exceptions/message_exception.dart';
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Headline3(child: Text('ルームに参加')),
              SizedBox(height: 8),
              FieldDecorator(
                label: Text('ルームIDの入力'),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'ルームIDを入力してください',
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryButton(
                    onPressed: () {
                      FullScreenLoadingIndicator.show(() async {
                        final roomId = _controller.text.trim();

                        if (roomId.isEmpty) {
                          throw MessageException('ルームIDを入力してください');
                        }

                        await ref.read(joinRoomUseCaseProvider)(roomId);
                      });
                    },
                    child: Text('参加'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
