import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/token_storage.dart';
import 'register_screen.dart';
import 'doctor_panel_screen.dart';
import 'patient_panel_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool loading = false;

  // ----------------------------
  // LOGIN FUNCTION
  // ----------------------------
  Future<void> login() async {
    if (loading) return;

    setState(() => loading = true);

    final res = await ApiService.post("/auth/login", {
      "username": username.text.trim(),
      "password": password.text.trim(),
    });

    if (!mounted) return;

    setState(() => loading = false);

    // ----------------------------
    // SUCCESS
    // ----------------------------
    if (res is Map && res["access_token"] != null) {
      final String token = res["access_token"];

      // 🔴 FIX: role backend se token me nahi aa raha hota kabhi kabhi
      final String role = res["user"]?["role"] ?? "";

      TokenStorage.saveToken(token, role);

      // ----------------------------
      // ROLE BASED REDIRECT
      // ----------------------------
      if (role == "doctor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DoctorPanelScreen()),
        );
      } else if (role == "patient") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatientPanelScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unknown role from server")),
        );
      }
    }

    // ----------------------------
    // ERROR
    // ----------------------------
    else {
      final message = res is Map
          ? (res["detail"] ?? res["message"] ?? "Login failed")
          : "Login failed";

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
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: username,
                    decoration: const InputDecoration(labelText: "Username"),
                  ),

                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : login,
                      child: loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Login"),
                    ),
                  ),

                  TextButton(
                    onPressed: loading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                    child: const Text("Create Account"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}