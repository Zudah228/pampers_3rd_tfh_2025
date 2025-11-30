import 'package:app/core/app/components/button/primary_button.dart';
import 'package:flutter/material.dart';

class DebugCompareFacesPage extends StatelessWidget {
  const DebugCompareFacesPage._();

  static const routeName = '/debug_compare_faces';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const DebugCompareFacesPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DebugCompareFacesPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [PrimaryButton(child: Text(''), onPressed: () {})],
        ),
      ),
    );
  }
}
