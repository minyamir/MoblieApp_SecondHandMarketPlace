import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

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

  Future<void> register(String fullName, String email, String password) async {
    await apiClient.dio.post('/auth/register', data: {
      'fullName': fullName,
      'email': email,
      'password': password,
    });
  }
}