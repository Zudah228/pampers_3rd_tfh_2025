import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod/riverpod.dart';

final packageInfoServiceProvider = Provider.autoDispose<PackageInfoService>((ref) {
  throw UnimplementedError(
    'PackageInfoService.init() を実行して packageInfoServiceProvider を override してください',
  );
});

class PackageInfoService {
  const PackageInfoService(this._packageInfo);

  final PackageInfo _packageInfo;

  static Future<PackageInfoService> init() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return PackageInfoService(packageInfo);
  }

  String get version => _packageInfo.version;
}
