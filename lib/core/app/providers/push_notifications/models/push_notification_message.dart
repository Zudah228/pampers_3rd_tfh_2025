import 'package:app/core/app/providers/push_notifications/models/push_notification_type.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

@immutable
sealed class PushNotificationMessage {
  const PushNotificationMessage();

  factory PushNotificationMessage.fromFirebaseRemoteMessage(
    RemoteMessage message,
  ) {
    return PushNotificationMessage.fromJson(message.data);
  }

  factory PushNotificationMessage.fromJson(Map<String, dynamic> data) {
    final type = PushNotificationMessageType.fromJson(data['type']);

    return switch (type) {
      _ => const UnknownPushNotificationMessage(),
    };
  }
  PushNotificationMessageType get type;
}

class UnknownPushNotificationMessage extends PushNotificationMessage {
  const UnknownPushNotificationMessage();

  @override
  PushNotificationMessageType get type => PushNotificationMessageType.unknown;
}
