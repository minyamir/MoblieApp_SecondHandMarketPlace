import 'package:dio/dio.dart';
// Fix: Use the correct path to core
import '../../../../core/network/api_client.dart'; 

class ListingsRemoteDataSource {
  final ApiClient apiClient; // Add this

  ListingsRemoteDataSource(this.apiClient); // Add constructor

 Future<List<dynamic>> fetchListings() async {
  final response = await apiClient.get('/listings');
  
  // LOG THIS to see exactly what the backend sends
  print("API Response Type: ${response.data.runtimeType}");
  print("API Response Body: ${response.data}");

  // If the response is a Map, extract the 'data' list
  if (response.data is Map && response.data['data'] != null) {
    return response.data['data'] as List<dynamic>;
  } 
  
  // If the response is already a List, return it directly
  if (response.data is List) {
    return response.data as List<dynamic>;
  }

  return []; // Fallback to empty list
}

  Future<void> uploadListing({
    required String title,
    required String description,
    required double price,
    required String category,
    required List<String> imagePaths,
  }) async {
    List<MultipartFile> multipartImages = [];
    for (String path in imagePaths) {
      multipartImages.add(await MultipartFile.fromFile(path));
    }

    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'images': multipartImages,
    });

    // Fix: Now apiClient is accessible via 'this'
    await apiClient.post('/listings/upload', data: formData);
  }
}