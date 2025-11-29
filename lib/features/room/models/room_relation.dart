import 'package:app/core/utils/json_converter/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_relation.freezed.dart';
part 'room_relation.g.dart';

@freezed
abstract class RoomRelation with _$RoomRelation {
  const factory RoomRelation({
    required String id,
    required String userId,
    @Default(false)
    bool enabled,
    @CreatedAtTimestampConverter() DateTime? createdAt,
    @UpdatedAtTimestampConverter() DateTime? updatedAt,
  }) = _RoomRelation;

  const RoomRelation._();

  factory RoomRelation.fromJson(Map<String, Object?> json) => _$RoomRelationFromJson(json);
}

typedef RoomRelationKeys = _$RoomRelationJsonKeys;

extension RoomRelationFirestoreExtension on CollectionReference<Map<String, dynamic>> {
  CollectionReference<RoomRelation> get withRoomRelationConverter => withConverter<RoomRelation>(
    fromFirestore: (snapshot, _) => RoomRelation.fromJson(snapshot.data()!),
    toFirestore: (user, _) => user.toJson(),
  );
}
