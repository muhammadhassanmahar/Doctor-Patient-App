import 'dart:io';
import 'package:flutter/material.dart';

class AppConstants {
  /// ----------------------------
  /// BASE URL (AUTO FIX FOR WEB + EMULATOR)
  /// ----------------------------
  static String get baseUrl {
    // Flutter Web
    if (identical(0, 0.0)) {
      return "http://localhost:8000";
    }

    // Android Emulator
    if (Platform.isAndroid) {
      return "http://10.0.2.2:8000";
    }

    // iOS / Desktop / Physical Device fallback
    return "http://localhost:8000";
  }

  /// ----------------------------
  /// API ENDPOINTS
  /// ----------------------------
  static const String loginUrl = "/login";
  static const String registerUrl = "/register";
  static const String recordsUrl = "/medical-records";
  static const String dashboardUrl = "/dashboard";

  /// ----------------------------
  /// APP THEME
  /// ----------------------------
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.purple;

  /// ----------------------------
  /// APP INFO
  /// ----------------------------
  static const String appName = "Doctor App";
}