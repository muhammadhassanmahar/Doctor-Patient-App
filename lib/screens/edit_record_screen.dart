import 'package:flutter/material.dart';
import '../models/record_model.dart';
import '../services/record_service.dart';

class EditRecordScreen extends StatefulWidget {
  final RecordModel record;

  const EditRecordScreen({super.key, required this.record});

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  late TextEditingController patientController;
  late TextEditingController diagnosisController;
  late TextEditingController prescriptionController;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    patientController =
        TextEditingController(text: widget.record.patient);

    diagnosisController =
        TextEditingController(text: widget.record.diagnosis);

    prescriptionController =
        TextEditingController(text: widget.record.prescription);
  }

  // ----------------------------
  // UPDATE RECORD
  // ----------------------------
  Future<void> updateRecord() async {
    if (loading) return;

    setState(() => loading = true);

    final data = {
      "patient": patientController.text.trim(),
      "diagnosis": diagnosisController.text.trim(),
      "prescription": prescriptionController.text.trim(),
    };

    final res = await RecordService.updateRecord(
      widget.record.id!,
      data,
    );

    if (!mounted) return;

    setState(() => loading = false);

    // ----------------------------
    // SUCCESS
    // ----------------------------
    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Record updated successfully")),
      );

      Navigator.pop(context, true);
    } 
    // ----------------------------
    // ERROR
    // ----------------------------
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update record")),
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
        title: const Text("Edit Record"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ----------------------------
            // PATIENT
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
            // UPDATE BUTTON
            // ----------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : updateRecord,
                child: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Update Record"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}