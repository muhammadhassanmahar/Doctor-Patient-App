import 'package:flutter/material.dart';

class DoctorPanelScreen extends StatelessWidget {
  const DoctorPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Panel")),
      body: const Center(
        child: Text("Doctor Dashboard",
            style: TextStyle(fontSize: 22)),
      ),
    );
  }
}