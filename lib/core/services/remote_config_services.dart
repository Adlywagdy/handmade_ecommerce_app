import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RemoteConfigService {
  RemoteConfigService._internal();

  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  static RemoteConfigService get instance => _instance;

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  bool _isInitialized = false;
  bool _isUpdateRequired = false;
  bool get isInitialized => _isInitialized;
  bool get isUpdateRequired => _isUpdateRequired;
  String get androidMinVersion => _remoteConfig.getString('android_min_version');

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 5),
      ),
    );
    await _remoteConfig.setDefaults(const {
      'android_min_version': '1.0.0',
    });
    await _remoteConfig.fetchAndActivate();
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final minVersion = _remoteConfig.getString('android_min_version');
    _isUpdateRequired = compareVersion(currentVersion, minVersion);
    _isInitialized = true;
    debugPrint('currentVersion == $currentVersion');
    debugPrint('minVersion == $minVersion');
    debugPrint('Required Update = $_isUpdateRequired');
  }

  Future<bool> refresh() async {
    await _remoteConfig.fetchAndActivate();
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final minVersion = _remoteConfig.getString('android_min_version');
    _isUpdateRequired = compareVersion(currentVersion, minVersion);
    debugPrint('currentVersion == $currentVersion');
    debugPrint('minVersion == $minVersion');
    debugPrint('Required Update = $_isUpdateRequired');
    return _isUpdateRequired;
  }

  bool compareVersion(String currentVersion,String minimumVersion){
    final currentParts = currentVersion.split('.').map(int.parse).toList(); //---->[1,0,0]
    final minimumParts = minimumVersion.split('.').map(int.parse).toList(); //---->[1,0,1]
    final length = currentParts.length > minimumParts.length ? currentParts.length : minimumParts.length;

    for(int i =0; i<length;i++){
      final current = i < currentParts.length ? currentParts[i] : 0;
      final minimum = i < minimumParts.length ? minimumParts[i] : 0;
      if (current < minimum) return true;
      if (current > minimum) return false;
    }
    return false;
  }
}