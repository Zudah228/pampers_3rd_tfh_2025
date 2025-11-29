import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

final firebaseMessagingServiceProvider =
    Provider.autoDispose<FirebaseMessagingService>(
  (_) {
    return FirebaseMessagingService(
      messaging: FirebaseMessaging.instance,
    );
  },
);

@immutable
class FirebaseMessagingService {
  const FirebaseMessagingService({required FirebaseMessaging messaging})
      : _messaging = messaging;

  final FirebaseMessaging _messaging;

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await setOptions();
    }
  }

  Future<void> setOptions() async {
    // iOS Options
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<RemoteMessage?> getInitialMessage() async {
    final message = await _messaging.getInitialMessage();

    return message;
  }

  Stream<RemoteMessage> get onBackgroundMessage {
    return FirebaseMessaging.onMessageOpenedApp.map((event) {
      log('FCM.onBackgroundMessage: ${_formatLogMessage(event)}');
      return event;
    });
  }

  Stream<RemoteMessage> get onForegroundMessage {
    return FirebaseMessaging.onMessage.map((event) {
      log('FCM.onForegroundMessage: ${_formatLogMessage(event)}');
      return event;
    });
  }

  String _formatLogMessage(RemoteMessage message) {
    return '''RemoteMessage(${message.messageId}, payload: ${message.data})''';
  }

  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  Future<void> deleteToken() async {
    await _messaging.deleteToken();
  }
}

// トップレベルの関数として定義しなければならない
// コンパイル時に消されるケースがあるので@pragma('mv:entry-point')をつける
@pragma('mv:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}