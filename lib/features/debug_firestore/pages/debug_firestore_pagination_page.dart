import 'package:app/core/app/components/pagination/paginated_list_view.dart';
import 'package:app/core/app/components/route_animations/route_animations.dart';
import 'package:app/features/debug_firestore/providers/debug_items_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DebugFirestorePaginationPage extends ConsumerWidget {
  const DebugFirestorePaginationPage._();

  static const routeName = '/debug_firestore_pagination';

  static Route<void> route() {
    return RouteAnimations.swipeBack<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const DebugFirestorePaginationPage._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: PaginatedListView.withAsyncNotifierProvider(
        provider: debugItemsProvider,
        builder: (items) {
          if (items.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                child: Text('No items'),
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => ListTile(
              key: ValueKey(items[index].data.id),
              title: Text(items[index].data.title ?? ''),
              subtitle: Text(items[index].data.content ?? ''),
            ),
          );
        },
      ),
    );
  }
}
