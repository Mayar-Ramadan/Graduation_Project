import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiScanService {
  Future<List<WiFiAccessPoint>> scanNetworks() async {
    final locationStatus = await Permission.location.request();

    if (!locationStatus.isGranted) {
      throw Exception('locationPermissionRequired');
    }

    final canScan = await WiFiScan.instance.canStartScan();

    if (canScan != CanStartScan.yes) {
      throw Exception('cannotStartWifiScan');
    }

    await WiFiScan.instance.startScan();

    final canGetResults = await WiFiScan.instance.canGetScannedResults();

    if (canGetResults != CanGetScannedResults.yes) {
      throw Exception('cannotGetWifiResults');
    }

    final results = await WiFiScan.instance.getScannedResults();

    final uniqueNetworks = <String, WiFiAccessPoint>{};

    for (final network in results) {
      if (network.ssid.isNotEmpty) {
        uniqueNetworks[network.ssid] = network;
      }
    }

    return uniqueNetworks.values.toList();
  }
}