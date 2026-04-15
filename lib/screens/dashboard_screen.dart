import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'doctor_panel_screen.dart';
import 'patient_panel_screen.dart';

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

      final token = ApiService.token;

      if (token == null) {
        Navigator.pop(context);
        return;
      }

      final role = _getRoleFromToken();

      _redirected = true;

      if (role == "doctor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DoctorPanelScreen()),
        );
      } else if (role == "patient") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatientPanelScreen()),
        );
      }
    });
  }

  // ----------------------------
  // TEMP ROLE FETCH (SAFE FALLBACK)
  // ----------------------------
  String? _getRoleFromToken() {
    // TODO: Improve later using SharedPreferences
    return null;
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