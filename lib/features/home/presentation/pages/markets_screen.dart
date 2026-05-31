import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HaHu/features/chat/presentation/provider/chat_bloc.dart';
import 'package:HaHu/core/di/injection_container.dart'; // To access your Service Locator 'sl'
import 'package:HaHu/features/chat/domain/repositories/chat_repository.dart';

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

  // Modified structure to track "isLiked" state per post item to allow full / clear state toggles.
  final List<Map<String, dynamic>> marketListings = [
    {
      "title": "Sony A7III Mirrorless Ca...",
      "price": "ETB 42,500",
      "seller": "Dawit M.",
      "rating": "4.9",
      "likes": 124, 
      "isLiked": false, // Tracks toggle state: true = filled, false = empty outline
      "condition": "Excellent",
      "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=300",
      "isVerified": true,
    },
    {
      "title": "MacBook Pro M2 14\" 512...",
      "price": "ETB 87,000",
      "seller": "Selam T.",
      "rating": "4.8",
      "likes": 98,
      "isLiked": true, // Pre-liked item example
      "condition": "Like New",
      "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=300",
      "isVerified": true,
    },
    {
      "title": "Pioneer HiFi Sound System",
      "price": "ETB 18,500",
      "seller": "Hirut B.",
      "rating": "4.8",
      "likes": 45,
      "isLiked": false,
      "condition": "Good",
      "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?w=300",
      "isVerified": true,
    },
    {
      "title": "Nikon D850 DSLR Kit",
      "price": "ETB 68,000",
      "seller": "Bereket A.",
      "rating": "4.7",
      "likes": 110,
      "isLiked": false,
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

            // 4. Counter Indicator 
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
              child: Text(
                "${marketListings.length} listings found",
                style: const TextStyle(
                  color: Color(0xFF475569), 
                  fontFamily: "monospace", 
                  fontSize: 13
                ),
              ),
            ),

            // 5. Equipment Card Layout Mesh
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.55, // Adjusted slightly to sit perfectly without item overflow
                ),
                itemCount: marketListings.length,
                itemBuilder: (context, index) {
                  final item = marketListings[index];
                  final bool currentlyLiked = item["isLiked"];

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
                              // Verified Label Flag
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
                              
                              // 🛠️ HEART (LIKE) TOGGLE ENGINE
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (currentlyLiked) {
                                        item["isLiked"] = false;
                                        item["likes"] -= 1; // Decrement counter logic
                                      } else {
                                        item["isLiked"] = true;
                                        item["likes"] += 1; // Increment counter logic
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: currentlyLiked ? Colors.redAccent.withOpacity(0.15) : Colors.black45,
                                      shape: BoxShape.circle,
                                      border: currentlyLiked 
                                          ? Border.all(color: Colors.redAccent, width: 1)
                                          : null,
                                    ),
                                    child: Icon(
                                      currentlyLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      color: currentlyLiked ? Colors.redAccent : Colors.white70,
                                      size: 18,
                                    ),
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
                                      const SizedBox(width: 6),
                                      
                                      // Real-time calculated Dynamic ranking display framework
                                      Icon(
                                        Icons.favorite, 
                                        color: currentlyLiked ? Colors.redAccent : const Color(0xFF64748B), 
                                        size: 12
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        "${item["likes"]}", 
                                        style: TextStyle(
                                          color: currentlyLiked ? Colors.redAccent : const Color(0xFF64748B), 
                                          fontSize: 11,
                                          fontWeight: currentlyLiked ? FontWeight.bold : FontWeight.normal
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Dual Action Framework Buttons 
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                          child: Row(
                            children: [
                              // 1. Negotiation System Integration Link
                              Expanded(
                                child: SizedBox(
                                  height: 34,
                                  child:OutlinedButton(
  onPressed: () {
    // Clear any existing snackbars to keep the UI snappy
    ScaffoldMessenger.of(context).clearSnackBars();
    
    // Safely generate a unique room identifier between buyer and item poster
    final String cleanRoomId = "room_${item['seller'].toString().trim().replaceAll(' ', '_')}";

    // Execute route transition with the BlocProvider wrapped directly around the ChatScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            // Uses your clean architecture locator container to safely fetch the data contract
            repository: sl<ChatRepository>(),
          ),
          child: ChatScreen(
            roomId: cleanRoomId,
            sellerName: item['seller'] ?? 'Verified Seller',
          ),
        ),
      ),
    );
  },
  style: OutlinedButton.styleFrom(
    foregroundColor: const Color(0xFF64748B),
    side: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
    padding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: const Text(
    "Negotiate", 
    style: TextStyle(
      fontWeight: FontWeight.bold, 
      fontSize: 12, 
      color: Colors.white70,
    ),
  ),
),
                                ),
                              ),
                              const SizedBox(width: 6),
                              
                              // 2. Direct Buy Trigger Implementation Action
                              Expanded(
                                child: SizedBox(
                                  height: 34,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: const Color(0xFF0F162A),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                        ),
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text("Instant Purchase Secure Checkout", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 10),
                                              Text("You are purchasing ${item['title']} listed by verified poster ${item['seller']} directly.", style: const TextStyle(color: Color(0xFF64748B))),
                                              const SizedBox(height: 8),
                                              Text("Total Transaction Cost: ${item['price']}", style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 24),
                                              SizedBox(
                                                width: double.infinity,
                                                height: 48,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFF00E676),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text("Processing escrow ledger balance payout safely...")),
                                                    );
                                                  },
                                                  child: const Text("Agree & Pay Securely", style: TextStyle(color: Color(0xFF070B15), fontWeight: FontWeight.bold)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00E676),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: const Text("Buy", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF070B15))),
                                  ),
                                ),
                              ),
                            ],
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