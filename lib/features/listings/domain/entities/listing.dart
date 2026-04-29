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
  });

  // Frontend Ranking Logic
  double get rankingScore {
    int freshnessHours = DateTime.now().difference(createdAt).inHours;
    double score = (likes * 2.0); // Likes carry heavy weight
    if (isVerifiedSeller) score += 10; // Bonus for verified sellers
    score -= (freshnessHours * 0.1); // Slight penalty for older posts
    return score;
  }
}