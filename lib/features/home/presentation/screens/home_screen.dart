import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../listings/presentation/provider/listings_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/category_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Current active tab

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListingsProvider>().loadListings();
    });
  }

  // List of widgets to show for each tab
  // For now, we show the Home content for index 0 and placeholders for others
  List<Widget> _getPages() {
    return [
      // Index 0: Home (Your existing UI)
      Column(
        children: [
          const HomeHeader(),
          const SizedBox(height: 10),
          CategoryList(),
          const SizedBox(height: 20),
          const Expanded(child: ListingsDisplayWidget()),
        ],
      ),
      // Index 1: Markets
      const Center(child: Text("Markets Screen")),
      // Index 2: Trade
      const Center(child: Text("Trade Screen")),
      // Index 3: My Listing
      const Center(child: Text("My Listings Screen")),
      // Index 4: Profile
      const Center(child: Text("Profile Screen")),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 // Inside _HomeScreenState
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF8F9FB), // Light grey background from your image
    body: SafeArea(
      child: _getPages()[_selectedIndex],
    ),
    // Styled Bottom Navigation
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
          selectedItemColor: const Color(0xFF0052CC), // The blue from your image
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          onTap: _onItemTapped,
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


class ListingsDisplayWidget extends StatelessWidget {
  const ListingsDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingsProvider>();

    if (provider.isLoading && provider.listings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.listings.isEmpty) {
      return const Center(child: Text("No items found in Bahir Dar."));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await provider.loadListings();
      },
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const AlwaysScrollableScrollPhysics(),
        // This creates two columns
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, // Adjust this to control the height of the cards
        ),
        itemCount: provider.listings.length,
        itemBuilder: (context, index) {
          final item = provider.listings[index];
          return ProductCard(item: item);
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic item;
  const ProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: item.images.isNotEmpty
                  ? Image.network(
                      item.images[0],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
            ),
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.price} ETB",
                  style: const TextStyle(
                    color: Color(0xFF0052CC), // The blue color from your navbar
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}