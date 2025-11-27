import 'package:flutter/material.dart';

abstract final class RouteAnimations {
  static Route<T> noAnimation<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, __, ___) => builder(context),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
    );
  }

  static Route<T> swipeBack<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) {
    return MaterialPageRoute<T>(
      builder: builder,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }
}
