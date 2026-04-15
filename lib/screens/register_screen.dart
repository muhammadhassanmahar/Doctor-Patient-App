import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  String role = "doctor";
  bool loading = false;

  // ----------------------------
  // REGISTER FUNCTION
  // ----------------------------
  Future<void> register() async {
    if (loading) return;

    setState(() => loading = true);

    final res = await ApiService.post("/register", {
      "username": username.text.trim(),
      "password": password.text.trim(),
      "role": role,
    });

    if (!mounted) return;

    setState(() => loading = false);

    // ----------------------------
    // SUCCESS
    // ----------------------------
    if (res is Map && res["message"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"])),
      );

      // optional: go back to login
      Navigator.pop(context);
    } 
    // ----------------------------
    // ERROR
    // ----------------------------
    else {
      final message = res is Map
          ? (res["detail"] ?? res["message"] ?? "Registration failed")
          : "Registration failed";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ----------------------------
            // USERNAME
            // ----------------------------
            TextField(
              controller: username,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ----------------------------
            // PASSWORD
            // ----------------------------
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // ----------------------------
            // ROLE SELECTOR
            // ----------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: role,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: "doctor",
                    child: Text("Doctor"),
                  ),
                  DropdownMenuItem(
                    value: "patient",
                    child: Text("Patient"),
                  ),
                ],
                onChanged: (v) {
                  setState(() => role = v!);
                },
              ),
            ),

            const SizedBox(height: 25),

            // ----------------------------
            // REGISTER BUTTON
            // ----------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : register,
                child: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}