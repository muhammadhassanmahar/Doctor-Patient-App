import 'package:flutter/material.dart';
import '../services/record_service.dart';
import '../models/record_model.dart';
import 'create_record_screen.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List<RecordModel> records = [];
  bool loading = true;

  // ----------------------------
  // FETCH RECORDS
  // ----------------------------
  Future<void> fetchRecords() async {
    setState(() => loading = true);

    final res = await RecordService.getRecords();

    if (!mounted) return;

    setState(() {
      records = res;
      loading = false;
    });
  }

  // ----------------------------
  // INIT
  // ----------------------------
  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  // ----------------------------
  // DELETE (TEMP)
  // ----------------------------
  Future<void> deleteRecord(String id) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Delete API not added yet")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Records"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchRecords,
          )
        ],
      ),

      // ----------------------------
      // BODY
      // ----------------------------
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : records.isEmpty
              ? const Center(child: Text("No Records Found"))
              : ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: const Icon(Icons.medical_services),
                        title: Text(record.patient),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Diagnosis: ${record.diagnosis}"),
                            Text("Prescription: ${record.prescription}"),
                          ],
                        ),

                        // ----------------------------
                        // ACTIONS
                        // ----------------------------
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "delete") {
                              if (record.id != null) {
                                deleteRecord(record.id!);
                              }
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

      // ----------------------------
      // ADD RECORD BUTTON
      // ----------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateRecordScreen(),
            ),
          );

          if (result == true) {
            fetchRecords();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}