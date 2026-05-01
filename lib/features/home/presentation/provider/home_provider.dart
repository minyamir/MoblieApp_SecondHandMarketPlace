import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String _selectedCategory = 'All';
  
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }
}