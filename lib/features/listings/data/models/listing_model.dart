class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final String category;
  final bool isVerifiedSeller;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.category,
    this.isVerifiedSeller = false,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'] ?? 'General',
      isVerifiedSeller: json['isVerifiedSeller'] ?? false,
    );
  }
}