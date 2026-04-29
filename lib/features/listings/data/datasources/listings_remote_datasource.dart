import '../../../../core/network/api_client.dart';

class ListingsRemoteDataSource {
  final ApiClient apiClient;
  ListingsRemoteDataSource(this.apiClient);

  Future<List<dynamic>> fetchListings() async {
    final response = await apiClient.dio.get('/listings');
    return response.data; // List of listings from your Node.js backend
  }
}