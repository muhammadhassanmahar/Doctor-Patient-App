import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'doctor_screen.dart';
import 'patient_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// ----------------------------
  /// LOGIN FUNCTION (API CONNECTED)
  /// ----------------------------
  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage("Please enter username and password");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final role = await AuthService.login(username, password);

      if (!mounted) return;

      if (role == "doctor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DoctorScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PatientScreen(),
          ),
        );
      }
    } catch (e) {
      _showMessage(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// ----------------------------
  /// SNACKBAR MESSAGE
  /// ----------------------------
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// ----------------------------
  /// UI
  /// ----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_hospital,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 10),
              const Text(
                "Hospital Management System",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              /// Username Field
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),

              /// Password Field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),

              /// Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : login,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 10),

              /// Register Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}