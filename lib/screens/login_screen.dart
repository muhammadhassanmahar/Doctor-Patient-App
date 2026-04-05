import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'doctor_screen.dart';
import 'patient_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final username = TextEditingController();
  final password = TextEditingController();

  void login() {
    // Dummy login (for demo)
    if (username.text == "doctor") {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => DoctorScreen()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => PatientScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text("Login",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

            SizedBox(height: 20),

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

            ElevatedButton(
              onPressed: login,
              child: Text("Login"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()));
              },
              child: Text("Create Account"),
            )
          ],
        ),
      ),
    );
  }
}