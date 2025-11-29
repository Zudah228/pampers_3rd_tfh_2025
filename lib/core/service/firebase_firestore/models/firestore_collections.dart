// ignore_for_file: constant_identifier_names, document_ignores, non_constant_identifier_names

abstract final class FirestoreCollections {
  const FirestoreCollections._();

  static const users = 'users';

  static const rooms = 'rooms';
  static String roomRelations(String userId) => '$users/$userId/related_rooms';

  static const debug_items = 'debug/v1/items';
}
