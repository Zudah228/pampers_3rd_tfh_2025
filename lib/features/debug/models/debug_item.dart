import 'package:app/core/utils/json_converter/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'debug_item.freezed.dart';
part 'debug_item.g.dart';

@freezed
abstract class DebugItem with _$DebugItem {
  const factory DebugItem({
    required String id,
    String? title,
    String? content,
    @CreatedAtTimestampConverter() DateTime? createdAt,
    @UpdatedAtTimestampConverter() DateTime? updatedAt,
  }) = _DebugItem;

  const DebugItem._();

  factory DebugItem.fromJson(Map<String, Object?> json) =>
      _$DebugItemFromJson(json);
}

typedef DebugItemKeys = _$DebugItemJsonKeys;

extension DebugItemFirestoreExtension
    on CollectionReference<Map<String, dynamic>> {
  CollectionReference<DebugItem> get withDebugItemConverter =>
      withConverter<DebugItem>(
        fromFirestore: (snapshot, _) => DebugItem.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );
}
