// ignore_for_file: non_constant_identifier_names

abstract final class StoragePaths {
  const StoragePaths._();

  static const users = 'users';
  static String user_avatar(String userId) => 'users/$userId/avatar/';
  static String room_key(String roomId) => 'room/$roomId/key/';
  static String room_photos(String roomId) => 'room/$roomId/photos/';
}
