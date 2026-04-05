import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final username = TextEditingController();
  final password = TextEditingController();

  String role = "patient";

  void register() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registered as $role")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: username,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            DropdownButtonFormField(
              value: role,
              items: [
                DropdownMenuItem(value: "patient", child: Text("Patient")),
                DropdownMenuItem(value: "doctor", child: Text("Doctor")),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Select Role",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: register,
              child: Text("Register"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}