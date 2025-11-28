// ignore_for_file: non_constant_identifier_names

abstract final class StoragePaths {
  const StoragePaths._();

  static const users = 'users';
  static String user_avatar(String userId, String filename) =>
      'users/$userId/avatar/$filename';
}
