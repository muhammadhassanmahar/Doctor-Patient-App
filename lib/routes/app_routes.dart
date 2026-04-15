import 'package:flutter/material.dart';

// Screens import
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/doctor_panel_screen.dart';
import '../screens/patient_panel_screen.dart';

class AppRoutes {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String dashboard = "/dashboard";
  static const String doctor = "/doctor";
  static const String patient = "/patient";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case doctor:
        return MaterialPageRoute(builder: (_) => const DoctorPanelScreen());

      case patient:
        return MaterialPageRoute(builder: (_) => const PatientPanelScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route Not Found")),
          ),
        );
    }
  }
}