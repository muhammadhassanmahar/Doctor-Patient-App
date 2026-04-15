import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static String? token;

  // ----------------------------
  // HEADERS
  // ----------------------------
  static Map<String, String> _headers() {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // ----------------------------
  // SAFE RESPONSE HANDLER
  // ----------------------------
  static dynamic _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        return {
          "error": true,
          "message": data["detail"] ?? "Something went wrong"
        };
      }
    } catch (e) {
      return {
        "error": true,
        "message": "Invalid server response"
      };
    }
  }

  // ----------------------------
  // GET REQUEST
  // ----------------------------
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
    );

    return _handleResponse(response);
  }

  // ----------------------------
  // POST REQUEST
  // ----------------------------
  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // ----------------------------
  // PUT REQUEST
  // ----------------------------
  static Future<dynamic> put(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // ----------------------------
  // LOGIN HELPER (FIX FOR YOUR ERROR)
  // ----------------------------
  static Future<bool> login(String username, String password) async {
    final res = await post("/login", {
      "username": username,
      "password": password,
    });

    if (res is Map && res["access_token"] != null) {
      token = res["access_token"];
      return true;
    }

    return false;
  }

  // ----------------------------
  // REGISTER HELPER (FIX FOR YOUR ERROR)
  // ----------------------------
  static Future<String> register(
      String username, String password, String role) async {
    final res = await post("/register", {
      "username": username,
      "password": password,
      "role": role,
    });

    if (res is Map && res["message"] != null) {
      return res["message"];
    }

    return "Registration failed";
  }
}