import 'package:flutter/material.dart';

class PatientPanelScreen extends StatelessWidget {
  const PatientPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patient Panel")),
      body: const Center(
        child: Text("Patient Dashboard",
            style: TextStyle(fontSize: 22)),
      ),
    );
  }
}