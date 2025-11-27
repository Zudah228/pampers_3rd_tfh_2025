// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_User',
  json,
  ($checkedConvert) {
    final val = _User(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String?),
      avatarPath: $checkedConvert('avatar_path', (v) => v as String?),
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
    'avatarPath': 'avatar_path',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

abstract final class _$UserJsonKeys {
  static const String id = 'id';
  static const String name = 'name';
  static const String avatarPath = 'avatar_path';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar_path': instance.avatarPath,
  'created_at': const CreatedAtTimestampConverter().toJson(instance.createdAt),
  'updated_at': const UpdatedAtTimestampConverter().toJson(instance.updatedAt),
};
