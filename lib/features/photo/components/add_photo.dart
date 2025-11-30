import 'dart:typed_data';

import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/form/image/image_field.dart';
import 'package:app/core/app/components/form/image/image_field_value.dart';
import 'package:app/core/app/components/full_screen_loading_indicator.dart';
import 'package:app/core/app/components/layout/layout.dart';
import 'package:app/core/app/components/snack_bar.dart';
import 'package:app/core/app/theme/app_colors.dart';
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
  bool _isAlreadyRegistered = false;
  bool _isLoading = false;

  Uint8List? get _image => switch (_value) {
    null || StoragePathImageValue() => null,
    MemoryImageValue(:final memory) => memory,
  };

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(myRoomProvider).value;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lightBeige,
            width: 1,
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'お題',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 16),
              Headline2(
                child: Text(
                  room?.getTodaySubject() ?? 'お題を読み込み中...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slateGray,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  return ImageField(
                    value: [?_value],
                    onChanged: (value) {
                      setState(() {
                        _value = value.firstOrNull;
                        _isAlreadyRegistered = false;
                      });
                    },
                    width: constraints.maxWidth,
                    height: 188,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: _isLoading || _isAlreadyRegistered
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                              _isAlreadyRegistered = false;
                            });

                            try {
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
                                _isLoading = false;
                              });
                            } on MessageException catch (e) {
                              // 登録済みの場合の特別処理
                              if (e.message == 'この日付の写真は既に登録済みです') {
                                setState(() {
                                  _isAlreadyRegistered = true;
                                  _isLoading = false;
                                });
                              } else {
                                showErrorSnackBar(error: e);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            } catch (e) {
                              // その他のエラーは通常のエラーハンドリング
                              FullScreenLoadingIndicator.show(() async {
                                throw e is Exception
                                    ? e
                                    : Exception(e.toString());
                              });
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                    backgroundColor: _isAlreadyRegistered
                        ? AppColors.slateGray
                        : null,
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(_isAlreadyRegistered ? '投稿完了' : '写真を追加'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
