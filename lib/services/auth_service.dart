import 'dart:convert';
import '../constants.dart';
import '../utils/token_storage.dart';
import 'api_service.dart';

class AuthService {
  /// ----------------------------
  /// LOGIN
  /// ----------------------------
  static Future<String> login(String username, String password) async {
    final response = await ApiService.post(
      AppConstants.loginUrl,
      {
        "username": username,
        "password": password,
      },
    );

    final String token = response["access_token"];
    await TokenStorage.saveToken(token);

    // Decode JWT to extract role and username
    final payload = _decodeJwt(token);
    final String role = payload["role"] ?? "patient";

    await TokenStorage.saveRole(role);

    return role;
  }

  /// ----------------------------
  /// REGISTER
  /// ----------------------------
  static Future<void> register(
    String username,
    String password,
    String role,
  ) async {
    await ApiService.post(
      AppConstants.registerUrl,
      {
        "username": username,
        "password": password,
        "role": role,
      },
    );
  }

  /// ----------------------------
  /// GET MEDICAL RECORDS
  /// ----------------------------
  static Future<Map<String, dynamic>> getRecords() async {
    return await ApiService.get(AppConstants.recordsUrl);
  }

  /// ----------------------------
  /// LOGOUT
  /// ----------------------------
  static Future<void> logout() async {
    await TokenStorage.clearAll();
  }

  /// ----------------------------
  /// GET SAVED ROLE
  /// ----------------------------
  static Future<String?> getSavedRole() async {
    return await TokenStorage.getRole();
  }

  /// ----------------------------
  /// JWT DECODER
  /// ----------------------------
  static Map<String, dynamic> _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception("Invalid JWT Token");
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decodedBytes = base64Url.decode(normalized);
    final decodedString = utf8.decode(decodedBytes);

    return jsonDecode(decodedString);
  }
}