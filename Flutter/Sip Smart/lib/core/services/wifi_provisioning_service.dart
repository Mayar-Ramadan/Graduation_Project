import 'dart:convert';
import 'package:http/http.dart' as http;

class WifiProvisioningResult {
  final bool success;
  final String? message;

  WifiProvisioningResult({
    required this.success,
    this.message,
  });
}

class WifiProvisioningService {
  static const String espBaseUrl = 'http://192.168.4.1';

  Future<WifiProvisioningResult> sendWifiCredentials({
    required String ssid,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse('$espBaseUrl/save-wifi'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'ssid': ssid,
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 20));

    final data = jsonDecode(response.body);

    return WifiProvisioningResult(
      success: data['success'] == true,
      message: data['message'],
    );
  }
}