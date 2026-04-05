import 'dart:convert';
import 'package:http/http.dart' as http;

// ⚠️ IMPORTANT:
// Android emulator → 10.0.2.2
// Real device → apne PC ka IP likho (e.g. 192.168.x.x)

const String baseUrl = "http://10.0.2.2:8000";

class ApiService {

  // ----------------------------
  // POST Request
  // ----------------------------
  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {

    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      body: data,
    );

    return _handleResponse(response);
  }

  // ----------------------------
  // GET Request (with token)
  // ----------------------------
  static Future<Map<String, dynamic>> get(
      String endpoint, String token) async {

    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    return _handleResponse(response);
  }

  // ----------------------------
  // Response Handler
  // ----------------------------
  static Map<String, dynamic> _handleResponse(http.Response response) {

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data["detail"] ?? "Something went wrong");
    }
  }
}