import '../entities/listing.dart';

abstract class ListingsRepository {
  Future<List<Listing>> getListings();
  
  Future<void> createListing({
    required String title,
    required String description,
    required double price,
    required String category,
    required List<String> imagePaths,
  });
}