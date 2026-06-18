import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'b1269746d4bf4e5b940154504261604';

  static Future<double> getCurrentTemperatureByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$latitude,$longitude',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather: ${response.body}');
    }

    final data = jsonDecode(response.body);

    if (data == null ||
        data['current'] == null ||
        data['current']['temp_c'] == null) {
      throw Exception('Invalid weather response');
    }

    return (data['current']['temp_c'] as num).toDouble();
  }
}