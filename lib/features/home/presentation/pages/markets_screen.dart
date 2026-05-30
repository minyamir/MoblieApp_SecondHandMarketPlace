import 'package:flutter/material.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> categories = const [
    "All",
    "Electronics",
    "Cameras",
    "Power Tools",
    "Automotive",
  ];

  final List<Map<String, dynamic>> marketListings = const [
    {
      "title": "Sony A7III Mirrorless Ca...",
      "price": "ETB 42,500",
      "seller": "Dawit M.",
      "rating": "4.9",
      "condition": "Excellent",
      "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=300",
      "isVerified": true,
    },
    {
      "title": "MacBook Pro M2 14\" 512...",
      "price": "ETB 87,000",
      "seller": "Selam T.",
      "rating": "4.8",
      "condition": "Like New",
      "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=300",
      "isVerified": true,
    },
    {
      "title": "Pioneer HiFi Sound System",
      "price": "ETB 18,500",
      "seller": "Hirut B.",
      "rating": "4.8",
      "condition": "Good",
      "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?w=300",
      "isVerified": true,
    },
    {
      "title": "Nikon D850 DSLR Kit",
      "price": "ETB 68,000",
      "seller": "Bereket A.",
      "rating": "4.7",
      "condition": "Excellent",
      "image": "https://images.unsplash.com/photo-1606486668508-34636b2d2777?w=300",
      "isVerified": true,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B15), // Dark Figma Canvas
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Section
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                "Market Browser",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // 2. Search & Filter Frame
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F162A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search listings...",
                          hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 22),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F162A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.tune_rounded, color: Color(0xFF64748B), size: 20),
                  ),
                ],
              ),
            ),

            // 3. Horizontal Categories Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategoryIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF00E676) : const Color(0xFF0F162A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF070B15) : const Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 4. FIXED PADDING POSITION RIGHT HERE 🛠️
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12), // Valid EdgeInset Tokens
              child: Text(
                "${marketListings.length} listings found",
                style: const TextStyle(
                  color: Color(0xFF475569), 
                  fontFamily: "monospace", 
                  fontSize: 13
                ),
              ),
            ),

            // 5. Main Equipment Grid Mesh
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.66,
                ),
                itemCount: marketListings.length,
                itemBuilder: (context, index) {
                  final item = marketListings[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F162A),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                  image: DecorationImage(
                                    image: NetworkImage(item["image"]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (item["isVerified"])
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00E676),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.verified_user_rounded, color: Color(0xFF070B15), size: 10),
                                        SizedBox(width: 4),
                                        Text(
                                          "VERIFIED",
                                          style: TextStyle(
                                            color: Color(0xFF070B15), 
                                            fontWeight: FontWeight.w900, 
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item["price"],
                                style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item["seller"], style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                      const SizedBox(width: 2),
                                      Text(item["rating"], style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                          child: SizedBox(
                            width: double.infinity,
                            height: 38,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF00E676),
                                side: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text("Negotiate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}