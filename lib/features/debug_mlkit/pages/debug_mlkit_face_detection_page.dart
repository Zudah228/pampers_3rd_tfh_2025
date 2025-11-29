import 'dart:typed_data';

import 'package:app/core/app/components/button/primary_button.dart';
import 'package:app/core/app/components/form/image/image_field.dart';
import 'package:app/core/app/components/form/image/image_field_value.dart';
import 'package:flutter/material.dart';

class DebugMlkitFaceDetectionPage extends StatefulWidget {
  const DebugMlkitFaceDetectionPage._();

  static const routeName = '/debug_mlkit_face_detection';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const DebugMlkitFaceDetectionPage._(),
    );
  }

  @override
  State<DebugMlkitFaceDetectionPage> createState() =>
      _DebugMlkitFaceDetectionPageState();
}

class _DebugMlkitFaceDetectionPageState
    extends State<DebugMlkitFaceDetectionPage> {
  ImageFieldValue? _value;

  Uint8List? get image => switch (_value) {
    null || StoragePathImageValue() => null,
    MemoryImageValue(:final memory) => memory,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('顔認証'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageField(
              value: [?_value],
              onChanged: (value) {
                setState(() {
                  _value = value.firstOrNull;
                });
              },
            ),
            SizedBox(height: 16),
            PrimaryButton(
              child: Text('解析'),
              onPressed: () {
                // TODO: 解析の実行
              },
            ),
          ],
        ),
      ),
    );
  }
}
