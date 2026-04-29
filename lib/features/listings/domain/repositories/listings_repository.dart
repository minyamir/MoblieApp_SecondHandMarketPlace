import '../entities/listing.dart';

abstract class ListingsRepository {
  Future<List<Listing>> getListings();
}