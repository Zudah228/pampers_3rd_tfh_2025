// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebugItem _$DebugItemFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_DebugItem',
  json,
  ($checkedConvert) {
    final val = _DebugItem(
      id: $checkedConvert('id', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String?),
      content: $checkedConvert('content', (v) => v as String?),
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
  fieldKeyMap: const {'createdAt': 'created_at', 'updatedAt': 'updated_at'},
);

abstract final class _$DebugItemJsonKeys {
  static const String id = 'id';
  static const String title = 'title';
  static const String content = 'content';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

Map<String, dynamic> _$DebugItemToJson(
  _DebugItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'created_at': const CreatedAtTimestampConverter().toJson(instance.createdAt),
  'updated_at': const UpdatedAtTimestampConverter().toJson(instance.updatedAt),
};
