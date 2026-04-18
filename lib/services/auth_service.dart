import 'api_service.dart';

class AuthService {
  // ----------------------------
  // REGISTER
  // ----------------------------
  static Future<String> register(
      String username, String password, String role) async {
    try {
      final res = await ApiService.post("/register", {
        "username": username,
        "password": password,
        "role": role,
      });

      if (res is Map && res["message"] != null) {
        return res["message"];
      }

      return "Registration failed";
    } catch (e) {
      return "Error: $e";
    }
  }

  // ----------------------------
  // LOGIN
  // ----------------------------
  static Future<String?> login(String username, String password) async {
    try {
      final res = await ApiService.post("/login", {
        "username": username,
        "password": password,
      });

      if (res is Map && res["access_token"] != null) {
        ApiService.token = res["access_token"];
        return res["access_token"]; // return token (useful for debug + future)
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // ----------------------------
  // DASHBOARD
  // ----------------------------
  static Future<Map<String, dynamic>> dashboard() async {
    try {
      final res = await ApiService.get("/dashboard");

      if (res is Map<String, dynamic>) {
        return res;
      }

      return {};
    } catch (e) {
      return {};
    }
  }
}