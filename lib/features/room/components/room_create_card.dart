import 'dart:typed_data';

import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/form/image/image_field.dart';
import 'package:app/core/app/components/form/image/image_field_value.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/exceptions/message_exception.dart';
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

  ImageFieldValue? _value;

  Uint8List? get _image => switch (_value) {
    null || StoragePathImageValue() => null,
    MemoryImageValue(:final memory) => memory,
  };

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
                  hintText: '名前を入力してください',
                ),
              ),
              SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageField(
                    value: [?_value],
                    onChanged: (value) {
                      setState(() {
                        _value = value.firstOrNull;
                      });
                    },
                  ),
                  PrimaryButton(
                    onPressed: () {
                      FullScreenLoadingIndicator.show(() async {
                        final data = _image;

                        if (data == null) {
                          throw MessageException('画像が必要です');
                        }
                        await ref.read(createRoomUseCaseProvider)(
                          data: data,
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
