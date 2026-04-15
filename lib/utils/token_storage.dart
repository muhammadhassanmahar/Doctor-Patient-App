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

    // API token sync
    ApiService.token = token;
  }

  // ----------------------------
  // GET TOKEN
  // ----------------------------
  static String? getToken() => _token;

  // ----------------------------
  // GET ROLE
  // ----------------------------
  static String? getRole() => _role;

  // ----------------------------
  // CHECK LOGIN STATUS
  // ----------------------------
  static bool isLoggedIn() {
    return _token != null && _token!.isNotEmpty;
  }

  // ----------------------------
  // CHECK ROLE HELPERS
  // ----------------------------
  static bool isDoctor() => _role == "doctor";
  static bool isPatient() => _role == "patient";

  // ----------------------------
  // CLEAR (LOGOUT)
  // ----------------------------
  static void clear() {
    _token = null;
    _role = null;
    ApiService.token = null;
  }
}