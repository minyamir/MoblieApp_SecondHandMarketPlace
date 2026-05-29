import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../listings/presentation/provider/listings_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/category_list.dart';
import '../pages/markets_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';  
import '../pages/trade_screen.dart';
import '../pages/my_listings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListingsProvider>().loadListings();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _HomeDashboardContent(
        searchController: _searchController,
        onSearchChanged: (val) => setState(() => _searchQuery = val),
        onInitiateTrade: () => _navigateToTab(2), // Redirect to Trade Tab
      ),
      const MarketsScreen(),  
      const TradeScreen(),    
      const MyListingsScreen(), 
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), 
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF0052CC), 
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            onTap: _navigateToTab,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Markets'),
              BottomNavigationBarItem(icon: Icon(Icons.swap_horizontal_circle_outlined), label: 'Trade'),
              BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), label: 'My Listing'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

/// Main Scrollable Dashboard Content
class _HomeDashboardContent extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onInitiateTrade;

  const _HomeDashboardContent({
    required this.searchController,
    required this.onSearchChanged,
    required this.onInitiateTrade,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(),
          
          // 1. Search Bar Filter Matrix
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search tools by name or max price...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0052CC)),
                suffixIcon: const Icon(Icons.tune_rounded, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 2. Platform Metrics Card with Interactive Bars
          const _PlatformStatsCard(),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text("Browse Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          CategoryList(),
          
          // 3. Highly Rated Tools Feed Grid
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text("Highly Rated Featured Tools", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          _FeaturedToolsGrid(onTradeAction: onInitiateTrade),

          // 4. Trust Testimonials Carousel
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text("Community Success Stories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const _TestimonialsCarousel(),

          // 5. NEW: Platform Trust & Core Services Section (Bottom Highlight)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Text("Why Trade on HaHu Market?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const _PlatformServicesShowcase(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

/// UI Component: Platform Growth Overview Stats & Bar Graphic
class _PlatformStatsCard extends StatelessWidget {
  const _PlatformStatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0052CC), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Active Marketplace Volume", style: TextStyle(color: Colors.white70, fontSize: 13)),
              SizedBox(height: 6),
              Text("12,450+ Users", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("⚡ 420 escrow orders secured today", style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          // Clean Visual Representation for Activity Trends
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildGraphBar(18),
                _buildGraphBar(28),
                _buildGraphBar(22),
                _buildGraphBar(38),
                _buildGraphBar(48),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGraphBar(double height) {
    return Container(
      width: 6,
      height: height,
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// UI Component: Biometric Verified Feedback Swiper Card
class _TestimonialsCarousel extends StatelessWidget {
  const _TestimonialsCarousel();

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {"name": "Bekele T.", "msg": "The biometric badge gives me immense confidence. Traded a heavy generator complete scam-free!", "loc": "Bahir Dar"},
      {"name": "Selam W.", "msg": "Secure escrow release protection saved my payment when checking power tool mechanics.", "loc": "Addis Ababa"}
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: reviews.length,
        itemBuilder: (context, i) {
          return Container(
            width: 290,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_user, color: Colors.green, size: 16),
                    const SizedBox(width: 6),
                    Text(reviews[i]["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(" • ${reviews[i]["loc"]}", style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '"${reviews[i]["msg"]}"',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// UI Component: NEW Platform Services Summary Grid (Bottom Layout)
class _PlatformServicesShowcase extends StatelessWidget {
  const _PlatformServicesShowcase();

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        "icon": Icons.gpp_good_rounded,
        "title": "AI Identity Check",
        "desc": "Every user completes National ID & biometric verification for absolute anti-fraud safety.",
        "color": const Color(0xFFE6F0FF),
        "iconColor": const Color(0xFF0052CC)
      },
      {
        "icon": Icons.account_balance_wallet_rounded,
        "title": "Secure Escrow Wallet",
        "desc": "Payments stay securely inside our protection lockup vault until you inspect the tool physically.",
        "color": const Color(0xFFE6FFFA),
        "iconColor": const Color(0xFF00A389)
      },
      {
        "icon": Icons.delivery_dining_rounded,
        "title": "Platform Delivery Riders",
        "desc": "Automated shipping and delivery handling via verified logistics agents straight to your door.",
        "color": const Color(0xFFFFF4E6),
        "iconColor": const Color(0xFFFF9900)
      }
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: services.map((srv) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: srv["color"] as Color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(srv["icon"] as IconData, color: srv["iconColor"] as Color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        srv["title"] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        srv["desc"] as String,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// UI Component: Highly Rated Tools Feed Grid
class _FeaturedToolsGrid extends StatelessWidget {
  final VoidCallback onTradeAction;
  const _FeaturedToolsGrid({required this.onTradeAction});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingsProvider>();

    if (provider.isLoading && provider.listings.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
    }

    if (provider.listings.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No high-rated tools online.")));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.73, 
      ),
      itemCount: provider.listings.length > 4 ? 4 : provider.listings.length,
      itemBuilder: (context, index) {
        final item = provider.listings[index];
        return ProductCard(item: item, onTradePressed: onTradeAction);
      },
    );
  }
}

/// Polished Product Card with Clean Architecture Trade Callbacks
class ProductCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTradePressed;
  
  const ProductCard({super.key, required this.item, required this.onTradePressed});

  @override
  Widget build(BuildContext context) {
    final hasImage = item.images != null && item.images.isNotEmpty;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: NetworkImage(hasImage ? item.images[0] : 'https://via.placeholder.com/150'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? 'Generic Equipment', 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item.price ?? 0} ETB", 
                      style: const TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: onTradePressed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0052CC).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Trade",
                          style: TextStyle(color: Color(0xFF0052CC), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}