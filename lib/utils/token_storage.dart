import '../services/api_service.dart';

class TokenStorage {
  static String? token;

  // SAVE TOKEN
  static void saveToken(String t) {
    token = t;
    ApiService.token = t;
  }

  // GET TOKEN
  static String? getToken() {
    return token;
  }

  // CLEAR TOKEN (LOGOUT)
  static void clear() {
    token = null;
    ApiService.token = null;
  }
}