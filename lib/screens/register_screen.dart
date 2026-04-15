import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  String role = "doctor";

  register() async {
    final res = await ApiService.register(
      username.text,
      password.text,
      role,
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: username, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: password, decoration: const InputDecoration(labelText: "Password")),

            DropdownButton<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: "doctor", child: Text("Doctor")),
                DropdownMenuItem(value: "patient", child: Text("Patient")),
              ],
              onChanged: (v) {
                setState(() => role = v!);
              },
            ),

            ElevatedButton(
              onPressed: register,
              child: const Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}