// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_Room',
  json,
  ($checkedConvert) {
    final val = _Room(
      id: $checkedConvert('id', (v) => v as String),
      createdBy: $checkedConvert('created_by', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String?),
      keyFilePath: $checkedConvert('key_file_path', (v) => v as String?),
      maxCount: $checkedConvert('max_count', (v) => (v as num).toInt()),
      currentCount: $checkedConvert('current_count', (v) => (v as num).toInt()),
      createdAt: $checkedConvert(
        'created_at',
        (v) => const CreatedAtTimestampConverter().fromJson(v),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => const UpdatedAtTimestampConverter().fromJson(v),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'createdBy': 'created_by',
    'keyFilePath': 'key_file_path',
    'maxCount': 'max_count',
    'currentCount': 'current_count',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

abstract final class _$RoomJsonKeys {
  static const String id = 'id';
  static const String createdBy = 'created_by';
  static const String name = 'name';
  static const String keyFilePath = 'key_file_path';
  static const String maxCount = 'max_count';
  static const String currentCount = 'current_count';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'id': instance.id,
  'created_by': instance.createdBy,
  'name': instance.name,
  'key_file_path': instance.keyFilePath,
  'max_count': instance.maxCount,
  'current_count': instance.currentCount,
  'created_at': const CreatedAtTimestampConverter().toJson(instance.createdAt),
  'updated_at': const UpdatedAtTimestampConverter().toJson(instance.updatedAt),
};
