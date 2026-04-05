import 'api_service.dart';

class AuthService {

  // Save token (simple variable for now)
  static String? token;
  static String? role;

  // ----------------------------
  // LOGIN
  // ----------------------------
  static Future<void> login(String username, String password) async {

    final res = await ApiService.post("/login", {
      "username": username,
      "password": password,
    });

    token = res["access_token"];

    // ⚠️ Role backend se decode nahi ho raha
    // is liye temporary logic:
    if (username.contains("doctor")) {
      role = "doctor";
    } else {
      role = "patient";
    }
  }

  // ----------------------------
  // REGISTER
  // ----------------------------
  static Future<void> register(
      String username, String password, String role) async {

    await ApiService.post("/register", {
      "username": username,
      "password": password,
      "role": role,
    });
  }

  // ----------------------------
  // GET MEDICAL RECORDS
  // ----------------------------
  static Future<Map<String, dynamic>> getRecords() async {

    if (token == null) {
      throw Exception("User not logged in");
    }

    return await ApiService.get("/medical-records", token!);
  }
}