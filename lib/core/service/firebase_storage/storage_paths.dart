// ignore_for_file: non_constant_identifier_names

abstract final class StoragePaths {
  const StoragePaths._();

  static const users = 'users';
  static String user_avatar(String userId) => 'users/$userId/avatar/';
  static String room_key(String roomId) => 'room/$roomId/key/';
}
