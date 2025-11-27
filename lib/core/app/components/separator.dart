import 'package:flutter/material.dart';

extension WidgetSeparator on List<Widget> {
  List<Widget> separatedWith(Widget separator) {
    return indexed
        .map((indexed) => [if (indexed.$1 > 0) separator, indexed.$2])
        .fold<List<Widget>>([], (acc, child) => [...acc, ...child]);
  }
}
