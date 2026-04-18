import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class PatientPanelScreen extends StatefulWidget {
  const PatientPanelScreen({super.key});

  @override
  State<PatientPanelScreen> createState() => _PatientPanelScreenState();
}

class _PatientPanelScreenState extends State<PatientPanelScreen> {
  bool isLoading = false;
  String message = "";
  dynamic records;

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  /// ----------------------------
  /// FETCH PATIENT RECORDS
  /// ----------------------------
  Future<void> fetchRecords() async {
    setState(() => isLoading = true);

    try {
      final res = await ApiService.get("/medical-records");

      if (res is Map && res["error"] == true) {
        setState(() {
          message = res["message"];
          records = null;
        });
      } else {
        setState(() {
          message = "Data loaded successfully";
          records = res;
        });
      }
    } catch (e) {
      setState(() {
        message = "Something went wrong";
      });
    }

    setState(() => isLoading = false);
  }

  /// ----------------------------
  /// LOGOUT
  /// ----------------------------
  void logout() {
    ApiService.token = null;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  /// ----------------------------
  /// UI
  /// ----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          )
        ],
      ),

      body: RefreshIndicator(
        onRefresh: fetchRecords,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "Welcome Patient 🧑‍⚕️",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    message,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  /// ACTION CARD
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.medical_information),
                      title: const Text("View My Medical Records"),
                      subtitle: const Text("Tap to refresh"),
                      onTap: fetchRecords,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "My Records",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  /// DATA DISPLAY
                  if (records == null)
                    const Text("No records found")
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          records.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}