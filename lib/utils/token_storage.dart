import '../services/api_service.dart';

class TokenStorage {
  static String? _token;
  static String? _role;

  // ----------------------------
  // SAVE TOKEN + ROLE
  // ----------------------------
  static void saveToken(String token, String role) {
    _token = token;
    _role = role;

    ApiService.token = token;
  }

  // ----------------------------
  // GET TOKEN
  // ----------------------------
  static String? getToken() {
    return _token;
  }

  // ----------------------------
  // GET ROLE
  // ----------------------------
  static String? getRole() {
    return _role;
  }

  // ----------------------------
  // CHECK LOGIN STATUS
  // ----------------------------
  static bool isLoggedIn() {
    return _token != null;
  }

  // ----------------------------
  // CLEAR (LOGOUT)
  // ----------------------------
  static void clear() {
    _token = null;
    _role = null;
    ApiService.token = null;
  }
}