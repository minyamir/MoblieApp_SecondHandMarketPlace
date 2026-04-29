import 'package:flutter/material.dart';
import '../../domain/entities/listing.dart';
import '../../data/datasources/listings_remote_datasource.dart';

class ListingsProvider extends ChangeNotifier {
  final ListingsRemoteDataSource remoteDataSource;
  List<Listing> _listings = [];
  bool _isLoading = false;

  ListingsProvider(this.remoteDataSource);

  List<Listing> get listings => _listings;
  bool get isLoading => _isLoading;

  Future<void> loadListings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final rawData = await remoteDataSource.fetchListings();
      
      // Map JSON to Entities
      _listings = rawData.map((json) => Listing(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        price: json['price'].toDouble(),
        images: List<String>.from(json['images']),
        category: json['category'],
        likes: json['likes'] ?? 0,
        isVerifiedSeller: json['seller']['isVerified'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
      )).toList();

      // APPLY SMART RANKING: Sort by rankingScore descending
      _listings.sort((a, b) => b.rankingScore.compareTo(a.rankingScore));

    } catch (e) {
      debugPrint("Error loading listings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}