import 'dart:async';
import 'dart:io';

import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:riverpod/riverpod.dart';

final nearbyDeviceServiceProvider = Provider.autoDispose<NearbyDeviceService>(
  (_) => NearbyDeviceService(NearbyService()),
);

class NearbyDeviceService {
  NearbyDeviceService(this._nearbyService) {
    init();
  }

  final NearbyService _nearbyService;

  static bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    await _nearbyService.init(
      serviceType: 'mp-connection',
      strategy: Strategy.P2P_CLUSTER,
      callback: (bool isRunning) async {
        if (isRunning) {
          await _nearbyService.stopBrowsingForPeers();
          await _nearbyService.stopAdvertisingPeer();
          await Future<void>.delayed(Duration(microseconds: 200));
          await _nearbyService.startBrowsingForPeers();
          await _nearbyService.startAdvertisingPeer();
        }
      },
    );
  }

  StreamSubscription<dynamic> devicesStream(
    void Function(List<Device> devices) onChanged,
  ) {
    return _nearbyService.stateChangedSubscription(
      callback: (list) {
        for (var device in list) {
          if (Platform.isAndroid) {
            if (device.state == SessionState.connected) {
              _nearbyService.stopBrowsingForPeers();
            } else {
              _nearbyService.startBrowsingForPeers();
            }
          }
        }
        onChanged(list);

        return list;
      },
    );
  }

  Future<void> sendMessage({
    required String deviceId,
    required String message,
  }) async {
    await _nearbyService.sendMessage(deviceId, message);
  }
}
