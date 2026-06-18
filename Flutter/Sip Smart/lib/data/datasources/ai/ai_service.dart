import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  Future<Map<String, dynamic>> getPrediction(List<dynamic> features) async {
    final response = await http.post(
      Uri.parse("http://10.155.22.56:8000/predict"),
      //http://192.168.1.2:8000/pr192.168.1.4edict
      //http://10.0.2.2:8000/predict
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "features": features,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && !data.containsKey("error")) {
      return data;
    } else {
      throw Exception('Server Error: ${response.body}');
    }
  }
}