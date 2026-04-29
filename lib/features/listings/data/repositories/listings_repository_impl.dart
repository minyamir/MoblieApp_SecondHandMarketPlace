import '../../domain/entities/listing.dart';
import '../../domain/repositories/listings_repository.dart';
import '../datasources/listings_remote_datasource.dart';

class ListingsRepositoryImpl implements ListingsRepository {
  final ListingsRemoteDataSource remoteDataSource;

  ListingsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Listing>> getListings() async {
    final List<dynamic> rawData = await remoteDataSource.fetchListings();
    
    return rawData.map((json) => Listing(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      images: List<String>.from(json['images']),
      category: json['category'],
      likes: json['likes'] ?? 0,
      isVerifiedSeller: json['seller']?['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    )).toList();
  }
}