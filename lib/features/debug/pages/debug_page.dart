import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/core/app/components/separator.dart';
import 'package:app/features/debug/pages/debug_components_page.dart';
import 'package:app/features/debug/pages/debug_fcm_page.dart';
import 'package:app/features/debug/pages/debug_firebase_page.dart';
import 'package:app/features/debug_firestore/pages/debug_firestore_pagination_page.dart';
import 'package:app/features/debug_form/pages/debug_form_page.dart';
import 'package:app/features/debug_nearby_device/pages/debug_nearby_device_page.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatelessWidget {
  const DebugPage._();

  static const routeName = '/debug';

  static Route<void> route() {
    return RouteAnimations.swipeBack<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const DebugPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DebugPage'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
        children: [
          _ListTile(
            leading: const Icon(Icons.widgets),
            title: const Text('コンポーネント一覧'),
            onTap: () {
              Navigator.push(context, DebugComponentsPage.route());
            },
          ),
          _ListTile(
            leading: const Icon(Icons.edit_document),
            title: const Text('フォーム'),
            onTap: () {
              Navigator.push(context, DebugFormPage.route());
            },
          ),
          _ListTile(
            leading: const Icon(Icons.nearby_off),
            title: const Text('近いデバイスと連携'),
            onTap: () {
              Navigator.push(context, DebugNearbyDevicePage.route());
            },
          ),
          _ListTile(
            leading: const Icon(Icons.fireplace_outlined),
            title: const Text('Firebase'),
            onTap: () {
              Navigator.push(context, DebugFirebasePage.route());
            },
          ),
          _ListTile(
            leading: const Icon(Icons.two_wheeler_rounded),
            title: const Text('Firestore ページネーション'),
            onTap: () {
              Navigator.push(context, DebugFirestorePaginationPage.route());
            },
          ),
          _ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('FCMトークン'),
            onTap: () {
              Navigator.push(context, DebugFcmPage.route());
            },
          ),
        ].separatedWith(const SizedBox(height: 16)),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.title, required this.onTap, this.leading});

  final Widget title;
  final Widget? leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 16,
        title: title,
        leading: leading,
        onTap: onTap,
      ),
    );
  }
}
