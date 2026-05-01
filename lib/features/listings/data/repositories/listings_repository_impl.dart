import '../../domain/entities/listing.dart';
import '../../domain/repositories/listings_repository.dart';
import '../datasources/listings_remote_datasource.dart';

class ListingsRepositoryImpl implements ListingsRepository {
  final ListingsRemoteDataSource remoteDataSource;

  ListingsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Listing>> getListings() async {
    try {
      // 1. Fetch raw data from the data source
      final dynamic responseData = await remoteDataSource.fetchListings();
      
      // 2. Handle cases where the backend wraps data in a 'data' field
      // (e.g., { "success": true, "data": [...] })
      final List<dynamic> list;
      if (responseData is List) {
        list = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        list = responseData['data'];
      } else {
        return [];
      }

      // 3. CRITICAL FIX: Explicitly map to <Listing> type
      return list.map<Listing>((json) => Listing.fromJson(json)).toList();
      
    } catch (e) {
      print("Repository Error: $e");
      return []; // Return empty list instead of crashing the UI
    }
  }

  @override
  Future<void> createListing({
    required String title, 
    required String description, 
    required double price, 
    required String category, 
    required List<String> imagePaths
  }) async {
    await remoteDataSource.uploadListing(
      title: title,
      description: description,
      price: price,
      category: category,
      imagePaths: imagePaths,
    );
  }
}