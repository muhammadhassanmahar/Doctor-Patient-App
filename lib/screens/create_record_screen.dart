import 'package:flutter/material.dart';
import '../services/record_service.dart';
import '../models/record_model.dart';

class CreateRecordScreen extends StatefulWidget {
  const CreateRecordScreen({super.key});

  @override
  State<CreateRecordScreen> createState() => _CreateRecordScreenState();
}

class _CreateRecordScreenState extends State<CreateRecordScreen> {
  final TextEditingController patientController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController prescriptionController = TextEditingController();

  bool loading = false;

  // ----------------------------
  // CREATE RECORD
  // ----------------------------
  Future<void> createRecord() async {
    if (loading) return;

    setState(() => loading = true);

    final record = RecordModel(
      id: "",
      patient: patientController.text.trim(),
      doctor: "",
      diagnosis: diagnosisController.text.trim(),
      prescription: prescriptionController.text.trim(),
      createdAt: DateTime.now(),
    );

    final res = await RecordService.createRecord(record);

    if (!mounted) return;

    setState(() => loading = false);

    // ----------------------------
    // SUCCESS
    // ----------------------------
    if (res != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Record created successfully")),
      );

      Navigator.pop(context, true);
    } 
    // ----------------------------
    // ERROR
    // ----------------------------
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create record")),
      );
    }
  }

  @override
  void dispose() {
    patientController.dispose();
    diagnosisController.dispose();
    prescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Medical Record"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ----------------------------
            // PATIENT NAME
            // ----------------------------
            TextField(
              controller: patientController,
              decoration: const InputDecoration(
                labelText: "Patient Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ----------------------------
            // DIAGNOSIS
            // ----------------------------
            TextField(
              controller: diagnosisController,
              decoration: const InputDecoration(
                labelText: "Diagnosis",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ----------------------------
            // PRESCRIPTION
            // ----------------------------
            TextField(
              controller: prescriptionController,
              decoration: const InputDecoration(
                labelText: "Prescription",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            // ----------------------------
            // SUBMIT BUTTON
            // ----------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : createRecord,
                child: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Create Record"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}