import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class DoctorPanelScreen extends StatefulWidget {
  const DoctorPanelScreen({super.key});

  @override
  State<DoctorPanelScreen> createState() => _DoctorPanelScreenState();
}

class _DoctorPanelScreenState extends State<DoctorPanelScreen> {
  bool isLoading = false;
  String message = "";
  List<dynamic> records = [];

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  /// ----------------------------
  /// FETCH MEDICAL RECORDS
  /// ----------------------------
  Future<void> fetchRecords() async {
    setState(() => isLoading = true);

    try {
      final res = await ApiService.get("/medical-records");

      if (res is Map && res["error"] == true) {
        setState(() {
          message = res["message"];
          records = [];
        });
      } else {
        setState(() {
          message = "Records loaded successfully";
          records = [res];
        });
      }
    } catch (e) {
      setState(() {
        message = "Error loading data";
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
        title: const Text("Doctor Dashboard"),
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
                    "Welcome Doctor 👨‍⚕️",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    message,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  /// QUICK ACTION CARDS
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: const Text("View Medical Records"),
                      subtitle: const Text("All patients data"),
                      onTap: fetchRecords,
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.refresh),
                      title: const Text("Refresh Data"),
                      onTap: fetchRecords,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DATA DISPLAY
                  const Text(
                    "Recent Data",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  if (records.isEmpty)
                    const Text("No records found")
                  else
                    ...records.map((e) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(e.toString()),
                        ),
                      );
                    }).toList(),
                ],
              ),
      ),
    );
  }
}