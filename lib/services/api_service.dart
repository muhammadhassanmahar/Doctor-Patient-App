import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000"; 
  // (Android emulator ke liye)

  static String? token;

  // ----------------------------
  // REGISTER
  // ----------------------------
  static Future<Map<String, dynamic>> register(
      String username, String password, String role) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "role": role,
      }),
    );

    return jsonDecode(response.body);
  }

  // ----------------------------
  // LOGIN
  // ----------------------------
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (data["access_token"] != null) {
      token = data["access_token"];
    }

    return data;
  }

  // ----------------------------
  // DASHBOARD
  // ----------------------------
  static Future<Map<String, dynamic>> dashboard() async {
    final response = await http.get(
      Uri.parse("$baseUrl/dashboard"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return jsonDecode(response.body);
  }
}