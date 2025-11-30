import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/form/field_decorator.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/app/components/layout/layout.dart';
import 'package:app/features/room/use_cases/create_room_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomCreateCard extends ConsumerStatefulWidget {
  const RoomCreateCard({super.key});

  @override
  ConsumerState<RoomCreateCard> createState() => _RoomCreateCardState();
}

class _RoomCreateCardState extends ConsumerState<RoomCreateCard> {
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
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Headline3(child: Text('ルーム作成')),
              SizedBox(height: 8),
              FieldDecorator(
                label: Text('ルーム名'),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: '名前を入力してください',
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
                        await ref.read(createRoomUseCaseProvider)(
                          name: _controller.text,
                        );
                      });
                    },
                    child: Text('作成'),
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
