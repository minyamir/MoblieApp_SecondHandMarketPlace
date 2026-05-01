import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import 'package:dio/dio.dart';
class AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSource(this.apiClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await apiClient.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data; // Should return {token, user}
  }

// lib/features/auth/data/datasources/auth_remote_datasource.dart

Future<Map<String, dynamic>> register(String name, String email, String password) async {
  try {
    final response = await apiClient.post('/auth/register', data: {
      'fullName': name, // <--- CHANGE THIS from 'name' to 'fullName'
      'email': email,
      'password': password,
    });
    return response.data; 
  } on DioException catch (e) {
    if (e.response != null) {
      print("Backend Validation Error: ${e.response?.data}");
    }
    throw Exception('Registration failed');
  }
}
}