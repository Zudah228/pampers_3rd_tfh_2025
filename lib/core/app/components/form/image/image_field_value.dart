import 'dart:typed_data';

sealed class ImageFieldValue {
  const ImageFieldValue();

  factory ImageFieldValue.storagePath(String path) = StoragePathImageValue;
  factory ImageFieldValue.memory(Uint8List memory) = MemoryImageValue;
}

class StoragePathImageValue extends ImageFieldValue {
  const StoragePathImageValue(this.path);

  final String path;
}

class MemoryImageValue extends ImageFieldValue {
  const MemoryImageValue(this.memory);

  final Uint8List memory;
}
