import 'dart:async';

import 'package:app/core/service/nearby_device/nearby_device_service.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nearbyDevicesProvider =
    NotifierProvider.autoDispose<NearbyDevicesNotifier, List<Device>>(() {
      return NearbyDevicesNotifier();
    });

class NearbyDevicesNotifier extends Notifier<List<Device>> {
  StreamSubscription<dynamic>? _streamSubscription;

  @override
  List<Device> build() {
    _streamSubscription?.cancel();
    _streamSubscription = ref.watch(nearbyDeviceServiceProvider).devicesStream((
      devices,
    ) {
      state = devices;
    });

    ref.onDispose(() {
      _streamSubscription?.cancel();
    });

    return [];
  }
}
