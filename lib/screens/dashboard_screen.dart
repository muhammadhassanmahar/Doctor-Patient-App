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
      final token = ApiService.token;

      if (token == null) {
        Navigator.pop(context);
        return;
      }

      // Decode role from stored login response (simple approach)
      // NOTE: better approach is storing role separately
      final role = _getRoleFromToken();

      if (role == "doctor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DoctorPanelScreen()),
        );
      } 
      else if (role == "patient") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatientPanelScreen()),
        );
      }
    });
  }

  // ----------------------------
  // TEMP ROLE FETCH (simple fix)
  // ----------------------------
  String? _getRoleFromToken() {
    // Because we stored only token, we fallback to API login response structure
    // Best practice: store role in shared storage later
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