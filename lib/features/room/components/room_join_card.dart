import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomJoinCard extends ConsumerWidget {
  const RoomJoinCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
        ),
      ),
    );
  }
}
