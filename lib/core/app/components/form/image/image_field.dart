import 'dart:math' as math;
import 'dart:typed_data';

import 'package:app/core/app/components/bottom_sheet/show_menu_modal.dart';
import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/button/secondary_button.dart';
import 'package:app/core/app/components/form/image/image_field_value.dart';
import 'package:app/core/app/components/future/error.dart';
import 'package:app/core/app/components/future/future_switcher.dart';
import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/core/service/firebase_storage/firebase_storage_service.dart';
import 'package:app/core/utils/riverpod/extensions.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImageField extends StatelessWidget {
  const ImageField({
    super.key,
    required this.value,
    required this.onChanged,
    this.fixedAspectRatio,
    this.maxCount = 1,
    this.height,
    this.width,
    this.decoration,
    this.addButton
  });

  final double? height;
  final double? width;
  final double? fixedAspectRatio;
  final Decoration? decoration;
  final List<ImageFieldValue> value;
  final ValueChanged<List<ImageFieldValue>> onChanged;
  final Widget? addButton;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    void addImage({required int index}) async {
      final image = await showImagePicker(
        context,
        fixedAspectRatio: fixedAspectRatio,
      );
      if (image == null) return;
      onChanged([
        for (var i = 0; i < maxCount; i++)
          if (i == index)
            ImageFieldValue.memory(image)
          else if (value.elementAtOrNull(i) case final v?)
            v,
      ]);
    }

    Widget buildAddButton() {
      return const Icon(Icons.add_a_photo);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < math.min(value.length + 1, maxCount); i++)
          Container(
            width: width ?? 88,
            height: height ?? 88,
            decoration:
                decoration ??
                (maxCount == 1
                    ? BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      )
                    : ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(8),
                        ),
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                      )),
            clipBehavior: .antiAlias,
            child: Material(
              type: .transparency,
              child: InkWell(
                onTap: () => addImage(index: i),
                child: switch (value.elementAtOrNull(i)) {
                  StoragePathImageValue(path: final path) => FutureSwitcher(
                    fetch: () => context
                        .watch(firebaseStorageServiceProvider)
                        .getDownloadURL(path),
                    builder: (url) => Image.network(url, fit: .cover),
                    errorBuilder: ErrorInline.new,
                  ),
                  MemoryImageValue(memory: final memory) => Image.memory(
                    memory,
                    fit: .cover,
                  ),
                  null => buildAddButton(),
                },
              ),
            ),
          ),
      ],
    );
  }
}

Future<Uint8List?> showImagePicker(
  BuildContext context, {
  double? fixedAspectRatio,
}) async {
  final source = await showMenuModal(
    context: context,
    entries: [
      MenuEntry(
        icon: Icon(Icons.camera_alt),
        child: Text('カメラ'),
        value: ImageSource.camera,
      ),
      MenuEntry(
        icon: Icon(Icons.photo),
        child: Text('アルバム'),
        value: ImageSource.gallery,
      ),
    ],
  );
  if (source == null) return null;

  final image = await ImagePicker().pickImage(source: source);
  if (image == null) return null;
  final bytes = await image.readAsBytes();

  if (!context.mounted) return null;

  final result = await Navigator.of(context).push(
    RouteAnimations.swipeBack<Uint8List>(
      builder: (context) => _CropPage(
        image: bytes,
        fixedAspectRatio: fixedAspectRatio,
      ),
    ),
  );

  return result;
}

class _CropPage extends StatefulWidget {
  const _CropPage({required this.image, this.fixedAspectRatio});

  final Uint8List image;
  final double? fixedAspectRatio;

  @override
  State<_CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<_CropPage> {
  final _controller = GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExtendedImage.memory(
        widget.image,
        cacheRawData: true,
        fit: BoxFit.contain,
        extendedImageEditorKey: _controller,
        mode: ExtendedImageMode.editor,
        initEditorConfigHandler: (state) {
          return EditorConfig(
            cropAspectRatio: widget.fixedAspectRatio,
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: .end,
          spacing: 16,
          children: [
            SecondaryButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('キャンセル'),
            ),
            PrimaryButton(
              onPressed: () async {
                final rect = _controller.currentState!.getCropRect();
                if (rect == null) return;
                final croppedImage = await _cropImageWithThread(
                  _controller.currentState!.rawImageData,
                  rect,
                );

                if (context.mounted) {
                  Navigator.of(context).pop(croppedImage);
                }
              },
              child: Text('切り取って適用'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> _cropImageWithThread(Uint8List image, Rect rect) async {
    img.Command cropTask = img.Command();
    cropTask.decodeImage(image);

    cropTask.copyCrop(
      x: rect.topLeft.dx.ceil(),
      y: rect.topLeft.dy.ceil(),
      height: rect.height.ceil(),
      width: rect.width.ceil(),
    );

    img.Command encodeTask = img.Command();
    encodeTask.subCommand = cropTask;
    encodeTask.encodeJpg();

    return encodeTask.getBytesThread();
  }
}
