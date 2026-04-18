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

  // ============================
  // FETCH RECORDS (FIXED ENDPOINT)
  // ============================
  Future<void> fetchRecords() async {
    setState(() => isLoading = true);

    try {
      final res = await ApiService.get("/records");

      if (res is Map && res["error"] == true) {
        message = res["message"];
        records = [];
      } else {
        message = "Records loaded successfully";

        if (res is Map && res["records"] != null) {
          records = res["records"];
        } else if (res is List) {
          records = res;
        } else {
          records = [];
        }
      }
    } catch (e) {
      message = "Server error occurred";
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
  // STATS CARD
  // ============================
  Widget statsCard(String title, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  // ============================
  // UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),

      appBar: AppBar(
        title: const Text("Doctor Dashboard"),
        backgroundColor: Colors.blue,
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

                  // ================= HEADER =================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Welcome Doctor 👨‍⚕️\nManage patients & prescriptions",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ================= STATS =================
                  Row(
                    children: [
                      statsCard("Records", Icons.folder, Colors.blue),
                      statsCard("Patients", Icons.people, Colors.purple),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    message,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 15),

                  // ================= ACTIONS =================
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.refresh, color: Colors.green),
                      title: const Text("Refresh Records"),
                      onTap: fetchRecords,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Patient Records",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ================= RECORD LIST =================
                  if (records.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No records found"),
                      ),
                    )
                  else
                    ...records.map((r) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(r["diagnosis"] ?? "No diagnosis"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Patient: ${r["patient"] ?? ""}"),
                              Text("Medicine: ${r["prescription"] ?? ""}"),
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