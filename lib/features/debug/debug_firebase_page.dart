import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/core/service/firebase/firebase_service.dart';
import 'package:app/features/auth/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DebugFirebasePage extends ConsumerWidget {
  const DebugFirebasePage._();

  static const routeName = '/debug_firebase';

  static Route<void> route() {
    return RouteAnimations.swipeBack<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const DebugFirebasePage._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final user = ref.watch(currentUserProvider);
    final firebaseApp = ref.watch(firebaseServiceProvider).app;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase'),
      ),
      body: SingleChildScrollView(
        padding: const .symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Firebase App', style: textTheme.titleLarge),
            Text(firebaseApp.options.projectId),

            SizedBox(height: 16),

            Text('Auth', style: textTheme.titleLarge),
            Text(user.toString()),
          ],
        ),
      ),
    );
  }
}
