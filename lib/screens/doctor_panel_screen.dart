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
  /// FETCH DATA
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
          message = "Data loaded successfully";
          records = [res];
        });
      }
    } catch (e) {
      setState(() {
        message = "Server error occurred";
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
  /// UI CARD (STATS)
  /// ----------------------------
  Widget _buildStatsCard(String title, IconData icon, Color color) {
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
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------
  /// UI
  /// ----------------------------
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
                  /// HEADER
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Welcome Doctor 👨‍⚕️\nManage your patients easily",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// STATS ROW
                  Row(
                    children: [
                      _buildStatsCard("Records", Icons.folder, Colors.blue),
                      _buildStatsCard("Patients", Icons.people, Colors.purple),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    message,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 15),

                  /// ACTION BUTTONS
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.medical_services,
                          color: Colors.blue),
                      title: const Text("View Medical Records"),
                      subtitle: const Text("All patient data"),
                      onTap: fetchRecords,
                    ),
                  ),

                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading:
                          const Icon(Icons.refresh, color: Colors.green),
                      title: const Text("Refresh Data"),
                      onTap: fetchRecords,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Recent Records",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  /// RECORD LIST
                  if (records.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No records found"),
                      ),
                    )
                  else
                    ...records.map((e) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            e.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 16),
                        ),
                      );
                    }).toList(),
                ],
              ),
      ),
    );
  }
}