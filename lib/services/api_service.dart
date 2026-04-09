import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../utils/token_storage.dart';

class ApiService {
  /// ----------------------------
  /// POST Request
  /// ----------------------------
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  /// ----------------------------
  /// GET Request (with token)
  /// ----------------------------
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    return _handleResponse(response);
  }

  /// ----------------------------
  /// PUT Request
  /// ----------------------------
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await TokenStorage.getToken();

    final response = await http.put(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  /// ----------------------------
  /// DELETE Request
  /// ----------------------------
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final token = await TokenStorage.getToken();

    final response = await http.delete(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    return _handleResponse(response);
  }

  /// ----------------------------
  /// Response Handler
  /// ----------------------------
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final dynamic decodedData =
        response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedData is Map<String, dynamic>
          ? decodedData
          : {"data": decodedData};
    } else {
      throw Exception(
        decodedData is Map<String, dynamic>
            ? decodedData["detail"] ?? "Something went wrong"
            : "Something went wrong",
      );
    }
  }
}