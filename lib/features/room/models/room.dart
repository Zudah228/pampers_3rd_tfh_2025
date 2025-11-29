import 'package:app/core/utils/json_converter/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
abstract class Room with _$Room {
  const factory Room({
    required String id,
    required String createdBy,
    required String? name,
    required String? keyFilePath,
    required int maxCount,
    required int currentCount,
    @CreatedAtTimestampConverter() DateTime? createdAt,
    @UpdatedAtTimestampConverter() DateTime? updatedAt,
  }) = _Room;

  const Room._();

  factory Room.fromJson(Map<String, Object?> json) => _$RoomFromJson(json);
}

typedef RoomKeys = _$RoomJsonKeys;

extension RoomFirestoreExtension on CollectionReference<Map<String, dynamic>> {
  CollectionReference<Room> get withRoomConverter => withConverter<Room>(
    fromFirestore: (snapshot, _) => Room.fromJson(snapshot.data()!),
    toFirestore: (room, _) => room.toJson(),
  );
}
