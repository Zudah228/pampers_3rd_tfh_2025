// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomRelation _$RoomRelationFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_RoomRelation',
      json,
      ($checkedConvert) {
        final val = _RoomRelation(
          id: $checkedConvert('id', (v) => v as String),
          userId: $checkedConvert('user_id', (v) => v as String),
          enabled: $checkedConvert('enabled', (v) => v as bool? ?? false),
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
        'userId': 'user_id',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
      },
    );

abstract final class _$RoomRelationJsonKeys {
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String enabled = 'enabled';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

Map<String, dynamic> _$RoomRelationToJson(
  _RoomRelation instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'enabled': instance.enabled,
  'created_at': const CreatedAtTimestampConverter().toJson(instance.createdAt),
  'updated_at': const UpdatedAtTimestampConverter().toJson(instance.updatedAt),
};
