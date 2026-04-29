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

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authRemoteDataSource.login(email, password);
      final token = response['token'];
      
      // Save token locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = "Login failed. Please check your credentials.";
      notifyListeners();
      return false;
    }
  }
}