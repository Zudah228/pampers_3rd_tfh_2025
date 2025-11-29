import 'package:app/core/app/components/button/tertiary_button.dart';
import 'package:app/core/app/components/future/error.dart';
import 'package:app/core/app/components/future/future_switcher.dart';
import 'package:app/core/app/components/layout/layout.dart';
import 'package:app/core/service/firebase_messaging/firebase_messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugFcmPage extends ConsumerWidget {
  const DebugFcmPage._();

  static const routeName = '/debug_fcm';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const DebugFcmPage._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Headline2(child: Text('FCM Token')),
          Body(
            children: [
              FutureSwitcher(
                fetch: ref.read(firebaseMessagingServiceProvider).getToken,
                builder: (token) {
                  return TertiaryButton(
                    onPressed: token != null
                        ? () {
                            Clipboard.setData(ClipboardData(text: token));
                          }
                        : null,
                    child: Text(token ?? '取得できませんでした'),
                  );
                },
                errorBuilder: ErrorInline.new,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
