import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final firebaseAuthServiceProvider = Provider.autoDispose<FirebaseAuthService>((
  Ref ref,
) {
  return const FirebaseAuthService();
});

class FirebaseAuthService {
  const FirebaseAuthService();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  User? get currentUser => _auth.currentUser;

  bool get isSignedIn => currentUser != null;

  Future<User?> signInWithCredential(AuthCredential credential) async {
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    return createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateDisplayName(String displayName) async {
    await currentUser?.updateDisplayName(displayName);
  }

  Future<void> updatePhotoURL(String photoURL) async {
    await currentUser?.updatePhotoURL(photoURL);
  }

  Future<void> deleteUser() async {
    await currentUser?.delete();
  }

  Future<void> reload() async {
    await currentUser?.reload();
  }

  Future<void> sendEmailVerification() async {
    await currentUser?.sendEmailVerification();
  }
}
