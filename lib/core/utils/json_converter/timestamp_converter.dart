import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class RequiredTimestampConverter implements JsonConverter<DateTime, Object?> {
  const RequiredTimestampConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    if (json is Map<String, Object?>) {
      final seconds = json['_seconds'];
      if (seconds is int) {
        return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      }
    }
    throw ArgumentError('Unsupported timestamp json: $json');
  }

  @override
  Object toJson(DateTime object) => Timestamp.fromDate(object);
}

class NullableTimestampConverter implements JsonConverter<DateTime?, Object?> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    return const RequiredTimestampConverter().fromJson(json);
  }

  @override
  Object? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

class CreatedAtTimestampConverter implements JsonConverter<DateTime?, Object?> {
  const CreatedAtTimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    return const RequiredTimestampConverter().fromJson(json);
  }

  @override
  Object? toJson(DateTime? object) => object == null
      ? FieldValue.serverTimestamp()
      : Timestamp.fromDate(object);
}

class UpdatedAtTimestampConverter implements JsonConverter<DateTime?, Object?> {
  const UpdatedAtTimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    return const RequiredTimestampConverter().fromJson(json);
  }

  @override
  Object? toJson(DateTime? object) => FieldValue.serverTimestamp();
}
