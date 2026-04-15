import 'package:flutter/material.dart';
import '../utils/token_storage.dart';
import 'doctor_panel_screen.dart';
import 'patient_panel_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _redirected = false;

  @override
  void initState() {
    super.initState();
    _redirectUser();
  }

  // ----------------------------
  // AUTO ROLE REDIRECT
  // ----------------------------
  void _redirectUser() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted || _redirected) return;

      final token = TokenStorage.getToken();
      final role = TokenStorage.getRole();

      _redirected = true;

      // ❌ NOT LOGGED IN
      if (token == null || token.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        return;
      }

      // ✅ DOCTOR
      if (role == "doctor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DoctorPanelScreen()),
        );
      }

      // ✅ PATIENT
      else if (role == "patient") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatientPanelScreen()),
        );
      }

      // ❌ UNKNOWN ROLE
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}