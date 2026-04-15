import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static String? token;

  // ----------------------------
  // GET REQUEST
  // ----------------------------
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
    );

    return jsonDecode(response.body);
  }

  // ----------------------------
  // POST REQUEST
  // ----------------------------
  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  // ----------------------------
  // PUT REQUEST
  // ----------------------------
  static Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  // ----------------------------
  // HEADERS
  // ----------------------------
  static Map<String, String> _headers() {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}