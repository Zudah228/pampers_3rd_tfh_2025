import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/core/service/firebase_messaging/firebase_messaging_service.dart';
import 'package:app/core/service/local_notifications/local_notifications_service.dart';
import 'package:async/async.dart';
import 'package:riverpod/riverpod.dart';

import 'models/push_notification_message.dart';

final pushNotificationRepositoryProvider = Provider<PushNotificationRepository>(
  (ref) {
    final firebaseMessaging = ref.watch(firebaseMessagingServiceProvider);
    final localNotificationsService = ref.watch(
      localNotificationsServiceProvider,
    );
    final instance = PushNotificationRepository(
      firebaseMessaging,
      localNotificationsService,
    );

    ref.onDispose(instance._onDispose);

    return instance;
  },
);

class PushNotificationRepository {
  PushNotificationRepository(this._firebaseMessaging, this._localNotifications);

  final FirebaseMessagingService _firebaseMessaging;

  final LocalNotificationsService _localNotifications;

  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }

  Future<void> initialize() async {
    await _localNotifications.onInit();

    _listenAndroidForegroundMessage();
  }

  StreamSubscription<dynamic>? _androidForegroundMessageSubscription;

  void _listenAndroidForegroundMessage() {
    if (!Platform.isAndroid) {
      return;
    }

    _androidForegroundMessageSubscription?.cancel();
    _androidForegroundMessageSubscription = _firebaseMessaging
        .onForegroundMessage
        .listen((message) {
          final payload = jsonEncode(message.data);
          final notification = message.notification;

          if (notification == null) {
            return;
          }

          _localNotifications.notify(
            id: message.hashCode,
            title: notification.title,
            body: notification.body,
            payload: payload,
          );
        });
  }

  void _onDispose() {
    _androidForegroundMessageSubscription?.cancel();
  }

  Future<PushNotificationMessage?> getInitialMessage() async {
    final message = await _firebaseMessaging.getInitialMessage();
    return message != null
        ? PushNotificationMessage.fromFirebaseRemoteMessage(message)
        : null;
  }

  Stream<PushNotificationMessage> get onMessage =>
      StreamGroup.merge([
        _firebaseMessaging.onBackgroundMessage.map(
          PushNotificationMessage.fromFirebaseRemoteMessage,
        ),
        _localNotifications.onTap.map(PushNotificationMessage.fromJson),
      ]).map((event) {
        log('onMessage: $event');
        return event;
      });
}
