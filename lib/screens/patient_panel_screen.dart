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
  Map<String, dynamic>? doctor;
  List<dynamic> records = [];

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  // ============================
  // FETCH DOCTOR + RECORDS
  // ============================
  Future<void> fetchAllData() async {
    setState(() => isLoading = true);

    try {
      final doctorRes = await ApiService.get("/my-doctor");
      final recordRes = await ApiService.get("/my-records");

      // Doctor
      if (doctorRes is Map && doctorRes["doctor"] != null) {
        doctor = Map<String, dynamic>.from(doctorRes["doctor"]);
      }

      // Records
      if (recordRes is Map && recordRes["records"] != null) {
        records = recordRes["records"];
      }

      message = "Data loaded successfully";
    } catch (e) {
      message = "Failed to load data";
    }

    setState(() => isLoading = false);
  }

  // ============================
  // LOGOUT
  // ============================
  void logout() {
    ApiService.token = null;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // ============================
  // UI
  // ============================
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
        onRefresh: fetchAllData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  // ================= WELCOME =================
                  const Text(
                    "Welcome Patient 🧑‍⚕️",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    message,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // ================= DOCTOR CARD =================
                  Card(
                    elevation: 3,
                    child: ListTile(
                      leading: const Icon(Icons.local_hospital),
                      title: const Text("My Doctor"),
                      subtitle: Text(
                        doctor != null
                            ? doctor!["username"]
                            : "No doctor assigned",
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= RECORDS TITLE =================
                  const Text(
                    "My Medical Records",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // ================= RECORD LIST =================
                  if (records.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("No medical records found"),
                      ),
                    )
                  else
                    ...records.map((r) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(Icons.medical_services),
                          title: Text(r["diagnosis"] ?? "No diagnosis"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Doctor: ${r["doctor"] ?? ""}"),
                              Text("Prescription: ${r["prescription"] ?? ""}"),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
      ),
    );
  }
}