import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/listings_provider.dart';
import '../../domain/entities/listing.dart';
class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load listings from the backend immediately when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListingsProvider>().loadListings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final listingsProvider = context.watch<ListingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("HaHu Market"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search items in Bahir Dar...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // 2. Body: Content Grid or Loading State
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => listingsProvider.loadListings(),
              child: listingsProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : listingsProvider.listings.isEmpty
                      ? const Center(child: Text("No items found yet."))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 items per row
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: listingsProvider.listings.length,
                          itemBuilder: (context, index) {
                            final item = listingsProvider.listings[index];
                            return _buildListingCard(item);
                          },
                        ),
            ),
          ),
        ],
      ),
      // 3. Floating Action Button to Post New Item
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-listing'),
        label: const Text("Sell Item"),
        icon: const Icon(Icons.add_a_photo),
      ),
    );
  }

// Change 'dynamic' to your actual 'Listing' class
Widget _buildListingCard(Listing item) { 
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey[300],
              image: item.images.isNotEmpty // Check if the list has images
                  ? DecorationImage(
                      image: NetworkImage(item.images[0]), // Use the first image
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.images.isEmpty
                ? const Center(child: Icon(Icons.image, color: Colors.grey))
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title, // Use .title instead of ['title']
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "ETB ${item.price}", // Use .price instead of ['price']
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              // Use .isVerifiedSeller from your Entity
              if (item.isVerifiedSeller)
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.blue, size: 14),
                    SizedBox(width: 4),
                    Text("Verified", style: TextStyle(fontSize: 12, color: Colors.blue)),
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