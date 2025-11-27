import 'package:app/core/utils/json_converter/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    String? name,
    String? avatarPath,
    @CreatedAtTimestampConverter() DateTime? createdAt,
    @UpdatedAtTimestampConverter() DateTime? updatedAt,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}

typedef UserKeys = _$UserJsonKeys;

extension UserFirestoreExtension on CollectionReference<Map<String, dynamic>> {
  CollectionReference<User> get withUserConverter => withConverter<User>(
    fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
    toFirestore: (user, _) => user.toJson(),
  );
}
