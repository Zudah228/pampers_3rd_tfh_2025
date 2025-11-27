import 'package:app/core/service/firebase/options/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod/riverpod.dart';

final firebaseServiceProvider = Provider.autoDispose((Ref ref) {
  return const FirebaseService();
});

class FirebaseService {
  const FirebaseService();

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirebaseApp get app => Firebase.app();
}
