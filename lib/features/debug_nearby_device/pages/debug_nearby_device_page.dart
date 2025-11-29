import 'package:app/core/app/providers/nearby_devices/nearby_devices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugNearbyDevicePage extends ConsumerWidget {
  const DebugNearbyDevicePage._();

  static const routeName = '/debug_nearby_device';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const DebugNearbyDevicePage._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(nearbyDevicesProvider);

    return Scaffold(
      appBar: AppBar(),
      body: devices.isEmpty
          ? Center(child: Text('接続デバイスはありません'))
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];

                return ListTile(
                  minVerticalPadding: 16,
                  title: Text(device.deviceName),
                );
              },
            ),
    );
  }
}
