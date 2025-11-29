import 'package:app/core/utils/json_converter/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo.freezed.dart';
part 'photo.g.dart';

@freezed
abstract class Photo with _$Photo {
  const factory Photo({
    required String id,
    required String roomId,
    required String userId,
    required String path,
    @CreatedAtTimestampConverter() DateTime? createdAt,
    @UpdatedAtTimestampConverter() DateTime? updatedAt,
  }) = _Photo;

  const Photo._();

  factory Photo.fromJson(Map<String, Object?> json) => _$PhotoFromJson(json);
}

typedef PhotoKeys = _$PhotoJsonKeys;

extension PhotoFirestoreExtension on CollectionReference<Map<String, dynamic>> {
  CollectionReference<Photo> get withPhotoConverter => withConverter<Photo>(
    fromFirestore: (snapshot, _) => Photo.fromJson(snapshot.data()!),
    toFirestore: (user, _) => user.toJson(),
  );
}
