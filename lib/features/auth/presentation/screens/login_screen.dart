import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("HaHu Market Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            TextButton(
                   onPressed: () => Navigator.pushNamed(context, '/register'),
               child: const Text("Don't have an account? Register here"),
                     ),
            const SizedBox(height: 20),
            authProvider.isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
  onPressed: () async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 🧪 HARDCODED MOCK DATA FOR USER TESTING
    const String testEmail = "test@gmail.com";
    const String testPassword = "123123";

    if (email == testEmail && password == testPassword) {
      if (mounted) {
        // Force navigate to home screen directly
        Navigator.pushReplacementNamed(context, '/home');
      }
      return; // Stop execution here
    }

    // --- ORIGINAL API CALL PIPELINE FOR PRODUCTION ---
    final success = await authProvider.login(email, password);
    
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? "Login failed. Check your connection."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }, 
  child: const Text("Login"),
),
          ],
        ),
      ),
    );
  }
}