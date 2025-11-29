// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Photo _$PhotoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_Photo',
  json,
  ($checkedConvert) {
    final val = _Photo(
      id: $checkedConvert('id', (v) => v as String),
      roomId: $checkedConvert('room_id', (v) => v as String),
      userId: $checkedConvert('user_id', (v) => v as String),
      path: $checkedConvert('path', (v) => v as String),
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
    'roomId': 'room_id',
    'userId': 'user_id',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

abstract final class _$PhotoJsonKeys {
  static const String id = 'id';
  static const String roomId = 'room_id';
  static const String userId = 'user_id';
  static const String path = 'path';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

Map<String, dynamic> _$PhotoToJson(_Photo instance) => <String, dynamic>{
  'id': instance.id,
  'room_id': instance.roomId,
  'user_id': instance.userId,
  'path': instance.path,
  'created_at': const CreatedAtTimestampConverter().toJson(instance.createdAt),
  'updated_at': const UpdatedAtTimestampConverter().toJson(instance.updatedAt),
};
