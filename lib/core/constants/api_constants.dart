import 'package:flutter/foundation.dart';

class ApiConstants {
  // 1. For Local Development: 
  // Use 10.0.2.2 for Android Emulator, or your Local IP (e.g., 192.168.1.5) for physical devices
  static const String _localBaseUrl = "http://10.0.2.2:5000"; 

  // 2. For Deployment:
  // Put your real domain here (e.g., https://api.hahu.com)
  static const String _productionBaseUrl = "https://your-hahu-backend.herokuapp.com";

  // 3. The Logic: Automatically switches based on how you build the app
  static const String baseUrl = kDebugMode ? _localBaseUrl : _productionBaseUrl;

  // You can also add your endpoints here for easy access
  static const String userMe = "$baseUrl/api/users/me";
  static const String login = "$baseUrl/api/auth/login";
  static const String verification = "$baseUrl/api/verification";
}