import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({Key? key}) : super(key: key);

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  late Future<Map<String, dynamic>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = AuthService.getRecords();
  }

  /// ----------------------------
  /// BUILD UI
  /// ----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Records"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          // Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error State
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          // No Data State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No medical records found.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final data = snapshot.data!;

          // Handle different API response formats
          final records = data["records"] ??
              data["data"] ??
              (data is List ? data : [data]);

          if (records.isEmpty) {
            return const Center(
              child: Text(
                "No medical records available.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // Display Records
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(
                    Icons.medical_services,
                    color: Colors.blue,
                  ),
                  title: Text(
                    record["title"]?.toString() ??
                        "Record ${index + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    record["description"]?.toString() ??
                        record.toString(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}