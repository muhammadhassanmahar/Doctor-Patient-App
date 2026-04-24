import 'api_service.dart';

class AuthService {
  // ====================================================
  // REGISTER
  // ====================================================
  static Future<String> register(
    String username,
    String password,
    String role,
  ) async {
    try {
      final res = await ApiService.post("/auth/register", {
        "username": username,
        "password": password,
        "role": role,
      });

      if (res is Map) {
        if (res["message"] != null) {
          return res["message"];
        }

        if (res["detail"] != null) {
          return res["detail"];
        }

        if (res["error"] == true) {
          return res["message"] ?? "Registration failed";
        }
      }

      return "Registration failed";
    } catch (e) {
      return "Error: $e";
    }
  }

  // ====================================================
  // LOGIN
  // ====================================================
  static Future<String?> login(
    String username,
    String password,
  ) async {
    try {
      final res = await ApiService.post("/auth/login", {
        "username": username,
        "password": password,
      });

      if (res is Map && res["access_token"] != null) {
        ApiService.token = res["access_token"];
        return res["access_token"];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // ====================================================
  // CURRENT USER
  // ====================================================
  static Future<Map<String, dynamic>> me() async {
    try {
      final res = await ApiService.get("/users/me");

      if (res is Map<String, dynamic>) {
        return res;
      }

      return {};
    } catch (e) {
      return {};
    }
  }

  // ====================================================
  // DASHBOARD
  // ====================================================
  static Future<Map<String, dynamic>> dashboard() async {
    try {
      final res = await ApiService.get("/users/dashboard");

      if (res is Map<String, dynamic>) {
        return res;
      }

      return {};
    } catch (e) {
      return {};
    }
  }

  // ====================================================
  // LOGOUT
  // ====================================================
  static void logout() {
    ApiService.token = null;
  }
}