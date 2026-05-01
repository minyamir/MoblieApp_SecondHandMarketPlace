import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/auth_remote_datasource.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRemoteDataSource authRemoteDataSource;
  
  bool _isLoading = false;
  String? _error;

  AuthProvider(this.authRemoteDataSource);

  bool get isLoading => _isLoading;
  String? get error => _error;

Future<bool> register(String name, String email, String password) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    // Now response is correctly identified as a Map<String, dynamic>
    final Map<String, dynamic> response = await authRemoteDataSource.register(name, email, password);
    
    if (response['token'] != null) {
      final token = response['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    }
    
    _isLoading = false;
    notifyListeners();
    return true;
  } catch (e) {
    _isLoading = false;
    _error = "Registration failed. Please try again.";
    notifyListeners();
    return false;
  }
}
Future<bool> login(String email, String password) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    final response = await authRemoteDataSource.login(email, password);
    
    // 1. DEBUG PRINT: Check the terminal to see exactly what the backend sent
    print("Full Backend Response: $response");

    // 2. Adjust based on your backend. If your backend returns 
    // { "success": true, "data": { "token": "..." } }, change the line below to:
    // final token = response['data']['token'];
    
    final token = response['token'] ?? response['data']?['token'];
    
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      print("Error: Token was null in the response");
      _error = "Server error: Token not found.";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    print("Flutter Process Error: $e");
    _isLoading = false;
    _error = "Login failed. Please check your credentials.";
    notifyListeners();
    return false;
  }
}
}
