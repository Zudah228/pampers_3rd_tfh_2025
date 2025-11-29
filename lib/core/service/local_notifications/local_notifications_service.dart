import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod/riverpod.dart';

final localNotificationsServiceProvider =
    Provider<LocalNotificationsService>((ref) {
  final instance = LocalNotificationsService(
    FlutterLocalNotificationsPlugin(),
  );

  ref.onDispose(instance._onDispose);

  return instance;
});

/// Android用の優先度の高い通知チャンネル
const _kAndroidChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.max,
);

class LocalNotificationsService {
  LocalNotificationsService(
    this._flutterLocalNotificationsPlugin,
  );

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  final StreamController<Map<String, dynamic>> _onTapController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onTap => _onTapController.stream;

  Future<void> onInit() async {
    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (event) {
        log('FlutterLocalNotificationsPlugin.'
            'onDidReceiveNotificationResponse: ${event.payload}');

        if (event.payload case final payload?) {
          _onTapController.add(jsonDecode(payload) as Map<String, dynamic>);
        }
      },
    );

    // Androidは優先度の高い通知チャンネルを使用しないとforeground時に通知が表示されない
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_kAndroidChannel);
  }

  void _onDispose() {
    _onTapController.close();
  }

  Future<void> notify({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async {
    // Androidはあらかじめ定義した_kAndroidChannelを使用する
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _kAndroidChannel.id,
          _kAndroidChannel.name,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
      payload: payload,
    );
    return;
  }
}