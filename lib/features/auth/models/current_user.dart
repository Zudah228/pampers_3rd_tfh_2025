import 'package:firebase_auth/firebase_auth.dart';

sealed class CurrentUser {
  const CurrentUser();

  factory CurrentUser.none() = NoneUser;
  factory CurrentUser.anonymous(User user) = AnonymousUser;
  factory CurrentUser.authenticated(User user) = AuthenticatedUser;

  factory CurrentUser.fromFirebaseUser(User? user) {
    if (user == null) {
      return NoneUser();
    } else if (user.isAnonymous) {
      return AnonymousUser(user);
    } else {
      return AuthenticatedUser(user);
    }
  }

  bool get isAnonymous;
  String? get id;
}

class NoneUser extends CurrentUser {
  const NoneUser();

  @override
  bool get isAnonymous => false;

  @override
  String? get id => null;

  @override
  String toString() => 'NoneUser()';
}

class AnonymousUser extends CurrentUser {
  const AnonymousUser(this.user);

  final User user;

  @override
  bool get isAnonymous => true;

  @override
  String? get id => user.uid;

  @override
  String toString() => 'AnonymousUser($id)';
}

class AuthenticatedUser extends CurrentUser {
  const AuthenticatedUser(this.user);

  final User user;

  @override
  bool get isAnonymous => false;

  @override
  String? get id => user.uid;

  @override
  String toString() => 'AuthenticatedUser($id)';
}
