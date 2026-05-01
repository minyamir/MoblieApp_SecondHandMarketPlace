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
  // Use .trim() to avoid errors caused by accidental spaces in email
  final success = await authProvider.login(
    _emailController.text.trim(), 
    _passwordController.text.trim(),
  );
  
  if (success && mounted) {
    Navigator.pushReplacementNamed(context, '/home');
  } else if (mounted) {
    // THIS WILL TELL YOU WHY NOTHING IS HAPPENING
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(authProvider.error ?? "Login failed. Check your connection."),
        backgroundColor: Colors.red,
      ),
    );
  }
}, 
                  child: const Text("Login")
                ),
          ],
        ),
      ),
    );
  }
}