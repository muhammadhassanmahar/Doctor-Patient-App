import 'package:flutter/material.dart';
import 'records_screen.dart';

class PatientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Patient Panel")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text("Welcome Patient 🧑",
                style: TextStyle(fontSize: 22)),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RecordsScreen()));
              },
              child: Text("View Medical Records"),
            )
          ],
        ),
      ),
    );
  }
}