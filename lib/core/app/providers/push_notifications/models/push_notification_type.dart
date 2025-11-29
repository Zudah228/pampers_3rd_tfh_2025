enum PushNotificationMessageType {
  unknown,
  ;

  static PushNotificationMessageType fromJson(dynamic json) {
    if (json is! String) {
      return unknown;
    }

    try {
      return PushNotificationMessageType.values.byName(json);
    } catch (_) {
      return unknown;
    }
  }
}