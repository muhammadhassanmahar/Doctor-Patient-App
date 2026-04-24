import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static String? token;

  /// ----------------------------
  /// BASE URL
  /// ----------------------------
  static String get baseUrl {
    try {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8000";
      }
      return "http://127.0.0.1:8000";
    } catch (e) {
      return "http://127.0.0.1:8000";
    }
  }

  /// ----------------------------
  /// HEADERS
  /// ----------------------------
  static Map<String, String> _headers() {
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// ----------------------------
  /// SAFE RESPONSE HANDLER
  /// ----------------------------
  static dynamic _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      }

      return {
        "error": true,
        "message": data["detail"] ?? data["message"] ?? "Request failed"
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Invalid server response"
      };
    }
  }

  // ====================================================
  // GENERAL REQUESTS
  // ====================================================

  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
    );
    return _handleResponse(response);
  }

  // ====================================================
  // AUTH HELPERS (🔥 FIXED ENDPOINTS)
  // ====================================================

  static Future<bool> login(String username, String password) async {
    final res = await post("/auth/login", {
      "username": username,
      "password": password,
    });

    if (res is Map && res["access_token"] != null) {
      token = res["access_token"];
      return true;
    }
    return false;
  }

  static Future<String> register(
    String username,
    String password,
    String role,
  ) async {
    final res = await post("/auth/register", {
      "username": username,
      "password": password,
      "role": role,
    });

    if (res is Map && res["message"] != null) {
      return res["message"];
    }

    if (res is Map && res["detail"] != null) {
      return res["detail"];
    }

    return "Registration failed";
  }

  // ====================================================
  // RECORDS SHORTCUTS
  // ====================================================

  static Future<dynamic> getRecords() async {
    return await get("/records");
  }

  static Future<dynamic> createRecord(Map<String, dynamic> data) async {
    return await post("/records", data);
  }
}