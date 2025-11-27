import 'dart:async';

import 'package:app/core/service/firebase_auth/firebase_auth_service.dart';
import 'package:app/features/auth/models/current_user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = NotifierProvider<CurrentUserNotifier, CurrentUser>(
  () => CurrentUserNotifier(),
);

class CurrentUserNotifier extends Notifier<CurrentUser> {
  FirebaseAuthService get _firebaseAuthService =>
      ref.read(firebaseAuthServiceProvider);

  StreamSubscription<dynamic>? _subscription;

  Future<void> _listen() async {
    await _subscription?.cancel();
    _subscription = _firebaseAuthService.authStateChanges().listen((user) {
      state = CurrentUser.fromFirebaseUser(user);
    });
  }

  @override
  CurrentUser build() {
    final user = _firebaseAuthService.currentUser;

    _listen();

    return CurrentUser.fromFirebaseUser(user);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthService.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

extension CurrentUserProviderExtension on Ref {
  String? get currentUserId => watch(currentUserProvider).id;
}

extension CurrentUserBuildContextExtension on BuildContext {
  String? get currentUserId =>
      ProviderScope.containerOf(this).read(currentUserProvider).id;
}
