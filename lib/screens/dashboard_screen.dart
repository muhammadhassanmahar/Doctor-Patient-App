import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'doctor_panel_screen.dart';
import 'patient_panel_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const DoctorPanelScreen()));
                },
                child: const Text("Doctor Panel"),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PatientPanelScreen()));
                },
                child: const Text("Patient Panel"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}