import 'package:flutter/foundation.dart';

class AppConstants {
  /// ----------------------------
  /// BASE URL CONFIGURATION
  /// ----------------------------
  /// Android Emulator  → http://10.0.2.2:8000
  /// Web (Chrome)      → http://localhost:8000
  /// Physical Device   → http://192.168.1.10:8000
  ///
  /// Note:
  /// - Physical device ke liye apne PC ka local IP use karein.
  /// - Ensure karein ke backend same network par run ho raha ho.

  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000";
    } else {
      return "http://10.0.2.2:8000";
    }
  }

  /// ----------------------------
  /// API ENDPOINTS
  /// ----------------------------
  static const String loginUrl = "/login";
  static const String registerUrl = "/register";
  static const String recordsUrl = "/medical-records";
}