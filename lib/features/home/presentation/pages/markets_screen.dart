import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../listings/presentation/provider/listings_provider.dart';
import '../widgets/sub_screen_header.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  final TextEditingController _marketSearchController = TextEditingController();
  double _maxPriceFilter = 25000; // Default threshold limit parameter
  String _selectedCategory = "All";

  final List<String> _marketCategories = ["All", "Power Tools", "Hand Tools", "Heavy Equipment", "Measurement"];

  @override
  void dispose() {
    _marketSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingsProvider>();

    // Client-side simulation filtering based on search query input fields matrix
    final filteredListings = provider.listings.where((item) {
      final matchesSearch = item.title?.toLowerCase().contains(_marketSearchController.text.toLowerCase()) ?? true;
      final matchesPrice = (item.price ?? 0) <= _maxPriceFilter;
      return matchesSearch && matchesPrice;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Reusable Top Header Module
        const SubScreenHeader(
          title: "Global Market", 
          subtitle: "Explore and query thousands of tools instantly",
        ),

        // 2. Advanced Search Text Input Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _marketSearchController,
            onChanged: (val) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Type tool name (e.g., Makita Hammer Drill)...",
              prefixIcon: const Icon(Icons.search, color: Color(0xFF0052CC)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                onPressed: () {
                  _marketSearchController.clear();
                  setState(() {});
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // 3. Dynamic Budget Filtering Slider Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Max Price Limit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                  Text("${_maxPriceFilter.toInt()} ETB", style: const TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              Slider(
                value: _maxPriceFilter,
                min: 500,
                max: 100000,
                activeColor: const Color(0xFF0052CC),
                inactiveColor: Colors.grey.shade200,
                onChanged: (val) {
                  setState(() {
                    _maxPriceFilter = val;
                  });
                },
              ),
            ],
          ),
        ),

        // 4. Horizontal Pill Filter Category Selector Row
        SizedBox(
          height: 40,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _marketCategories.length,
            itemBuilder: (context, idx) {
              final isSelected = _selectedCategory == _marketCategories[idx];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = _marketCategories[idx]),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0052CC) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
                  ),
                  child: Text(
                    _marketCategories[idx],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // 5. Global Catalog Infinite View Feed Builder Layout
        Expanded(
          child: provider.isLoading && provider.listings.isEmpty
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF0052CC)))
              : filteredListings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text("No tools match your query metrics.", style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFF0052CC),
                      onRefresh: () async => await provider.loadListings(),
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.76,
                        ),
                        itemCount: filteredListings.length,
                        itemBuilder: (context, index) {
                          final item = filteredListings[index];
                          return _MarketCatalogCard(item: item);
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}

/// Dedicated Premium Product Card Component with AI Verification Badges
class _MarketCatalogCard extends StatelessWidget {
  final dynamic item;
  const _MarketCatalogCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final hasImage = item.images != null && item.images.isNotEmpty;
    // Simulation verifying if account completed biometric liveness + National ID checking checks
    final isVerifiedSeller = true; 

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                // Product Image
                Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(hasImage ? item.images[0] : 'https://via.placeholder.com/150'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Premium Green Anti-Scam Verification Badge Overlays
                if (isVerifiedSeller)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.verified_user_rounded, color: Colors.white, size: 10),
                          SizedBox(width: 3),
                          Text(
                            "VERIFIED", 
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 8, 
                              fontWeight: FontWeight.w900, // Fixed here from .black
                              letterSpacing: 0.5
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
            padding: const EdgeInsets.fromLTRB(12, 2, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? 'Equipment Unit',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item.price ?? 0} ETB",
                      style: const TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.w900, fontSize: 13),
                    ),
                    Icon(
                      Icons.arrow_circle_right_rounded, // Fixed here to valid material icon
                      color: const Color(0xFF0052CC).withOpacity(0.8), 
                      size: 22,
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