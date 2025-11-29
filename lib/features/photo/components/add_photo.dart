import 'dart:typed_data';

import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/form/image/image_field.dart';
import 'package:app/core/app/components/form/image/image_field_value.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/app/components/layout/layout.dart';
import 'package:app/core/exceptions/message_exception.dart';
import 'package:app/features/photo/use_cases/add_photo_use_case.dart';
import 'package:app/features/room/providers/my_room_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPhoto extends ConsumerStatefulWidget {
  const AddPhoto({super.key});

  @override
  ConsumerState<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends ConsumerState<AddPhoto> {
  ImageFieldValue? _value;

  Uint8List? get _image => switch (_value) {
    null || StoragePathImageValue() => null,
    MemoryImageValue(:final memory) => memory,
  };

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(myRoomProvider).value;

    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: お題を表示
              Headline2(child: Text('最近食べたご飯は何でしたか？')),
              const SizedBox(height: 8),
              // 写真で回答
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

                        if (room == null) {
                          throw MessageException('ルームが見つかりません');
                        }

                        await ref.read(addPhotoUseCaseProvider)(
                          roomId: room.id,
                          data: data,
                        );

                        // 成功したら画像をクリア
                        setState(() {
                          _value = null;
                        });
                      });
                    },
                    child: const Text('追加'),
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
