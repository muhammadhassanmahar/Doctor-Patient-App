import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static String? token;

  /// ----------------------------
  /// BASE URL (AUTO FIX WEB + EMULATOR)
  /// ----------------------------
  static String get baseUrl {
    try {
      // Android Emulator
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8000";
      }
      // iOS / Desktop
      return "http://127.0.0.1:8000";
    } catch (e) {
      // Flutter Web fallback
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
  /// RESPONSE HANDLER
  /// ----------------------------
  static dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    return {
      "error": true,
      "message": data["detail"] ?? data["message"] ?? "Request failed"
    };
  }

  /// ----------------------------
  /// GET
  /// ----------------------------
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
    );

    return _handleResponse(response);
  }

  /// ----------------------------
  /// POST
  /// ----------------------------
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

  /// ----------------------------
  /// PUT
  /// ----------------------------
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

  /// ----------------------------
  /// DELETE
  /// ----------------------------
  static Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(),
    );

    return _handleResponse(response);
  }
}