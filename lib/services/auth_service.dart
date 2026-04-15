import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  // ----------------------------
  // REGISTER
  // ----------------------------
  static Future<String> register(
      String username, String password, String role) async {
    final res = await ApiService.post("/register", {
      "username": username,
      "password": password,
      "role": role,
    });

    return res["message"] ?? "Error";
  }

  // ----------------------------
  // LOGIN
  // ----------------------------
  static Future<bool> login(String username, String password) async {
    final res = await ApiService.post("/login", {
      "username": username,
      "password": password,
    });

    if (res["access_token"] != null) {
      ApiService.token = res["access_token"];
      return true;
    }

    return false;
  }

  // ----------------------------
  // GET DASHBOARD
  // ----------------------------
  static Future<Map<String, dynamic>> dashboard() async {
    return await ApiService.get("/dashboard");
  }
}