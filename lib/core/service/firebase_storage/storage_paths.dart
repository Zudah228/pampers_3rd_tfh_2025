// ignore_for_file: non_constant_identifier_names

abstract final class StoragePaths {
  const StoragePaths._();

  static const users = 'users';
  static String user_avatar(String userId) => 'users/$userId/avatar/';
  static String room_faces(String roomId) => 'room/$roomId/faces/';
  static String room_photos(String roomId) => 'room/$roomId/photos/';
}
