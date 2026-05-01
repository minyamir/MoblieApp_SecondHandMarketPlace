class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final int likes;
  final bool isVerifiedSeller;
  final DateTime createdAt;
  final String location; // Ensure this is here

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.likes,
    required this.isVerifiedSeller,
    required this.createdAt,
    required this.location,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      location: json['location'] ?? 'Unknown',
      
      // FIX FOR: 'List<dynamic>' is not a subtype of type 'int'
  // Inside Listing.fromJson in listing.dart
likes: (json['likes'] is List) 
    ? (json['likes'] as List).length 
    : (json['likesCount'] ?? 0),

      isVerifiedSeller: (json['seller'] != null && json['seller'] is Map)
          ? (json['seller']['isVerified'] ?? false)
          : false,

      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),

      images: json['images'] != null 
          ? List<String>.from(json['images']).map((img) {
              String cleanPath = img.replaceAll(r'\', '/');
              return "http://localhost:5000/$cleanPath"; 
            }).toList() 
          : [],
    );
  }
}