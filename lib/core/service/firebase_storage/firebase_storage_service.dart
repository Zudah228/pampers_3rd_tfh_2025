import 'dart:typed_data';

import 'package:app/core/utils/unique_string_generator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod/riverpod.dart';

final firebaseStorageServiceProvider = Provider.autoDispose(
  (Ref ref) => FirebaseStorageService(FirebaseStorage.instance),
);

class FirebaseStorageService {
  const FirebaseStorageService(this._storage);

  final FirebaseStorage _storage;

  Future<String> getDownloadURL(String path) async {
    final url = await _storage.ref().child(path).getDownloadURL();
    return url;
  }

  Future<String> uploadImage(
    String directoryPath,
    Uint8List imageBinary, {
    CompressFormat format = CompressFormat.jpeg,
    int minHeight = 1024,
    int minWidth = 1024,
  }) async {
    final ext = switch (format) {
      CompressFormat.jpeg => '.jpg',
      CompressFormat.png => '.png',
      CompressFormat.heic => '.heic',
      CompressFormat.webp => '.webp',
    };
    final path = p.join(directoryPath, UniqueStringGenerator.hashcode() + ext);
    final storageRef = _storage.ref().child(path);
    imageBinary = await FlutterImageCompress.compressWithList(
      imageBinary,
      minHeight: minHeight,
      minWidth: minWidth,
      format: format,
    );

    // MIMEタイプを動的に設定
    final mimeType = switch (format) {
      CompressFormat.jpeg => 'image/jpeg',
      CompressFormat.png => 'image/png',
      CompressFormat.heic => 'image/heic',
      CompressFormat.webp => 'image/webp',
    };

    final metadata = SettableMetadata(contentType: mimeType);

    // データをアップロード
    final snapshot = await storageRef.putData(imageBinary, metadata);
    if (snapshot.state == TaskState.success) {
      return path;
    } else {
      throw Exception('Failed to upload image');
    }
  }
}
