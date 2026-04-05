import 'package:flutter/material.dart';

class RecordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Records"),
      ),
      body: Center(
        child: Text(
          "Here medical records will be shown",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}