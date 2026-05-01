import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart'; 
import '../../../../core/di/injection_container.dart'; 
import '../../domain/entities/listing.dart';

class ListingsProvider extends ChangeNotifier {
  List<Listing> _listings = [];
  bool _isLoading = false;

  List<Listing> get listings => _listings;
  bool get isLoading => _isLoading;

  Future<void> loadListings() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Now 'sl' and 'ApiClient' will be recognized
      final response = await sl<ApiClient>().get('/listings'); 
      
      final List<dynamic> rawData = response.data['data'];

      // Mapping and casting to List<Listing>
      _listings = rawData.map((item) => Listing.fromJson(item)).toList().cast<Listing>();

      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      debugPrint("Error loading listings: $e");
    }
    
    notifyListeners();
  }
}