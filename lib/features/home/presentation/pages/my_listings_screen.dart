import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../listings/presentation/provider/listings_provider.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  // Explicit persistent form controllers preventing state decay inside modals
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingsProvider>();
    final myOwnedListings = provider.listings;

    return Scaffold(
      backgroundColor: const Color(0xFF070B19), // Matches HaHu deep space black canvas
      body: SafeArea(
        child: Column(
          children: [
            // Studio Header Frame with Floating Add Action
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Listings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showPostItemSheet(context),
                    icon: const Icon(Icons.add, size: 20, color: Color(0xFF070B19)),
                    label: const Text(
                      "Post Item",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676), // High contrast neon green anchor
                      foregroundColor: const Color(0xFF070B19),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF00E676)))
                  : myOwnedListings.isEmpty
                      ? _buildEmptyState(context)
                      : _buildListingsInventory(context, myOwnedListings),
            ),
          ],
        ),
      ),
    );
  }

  /// Onboarding Placeholder View
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1527),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF151D30)),
              ),
              child: const Icon(
                Icons.hourglass_empty_rounded,
                size: 50,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Active Inventory",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your secure workbench catalog is empty. Tap 'Post Item' to list equipment under escrow protection.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  /// Active Inventory Dashboard Frame matching your metrics layout
  Widget _buildListingsInventory(BuildContext context, List<dynamic> listings) {
    // Computing stateful metrics variables safely
    final int activeCount = listings.length;
    
    return Column(
      children: [
        // Analytics Row Cards Matrix
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              Expanded(child: _buildMetricCard("2", "Active", const Color(0xFF00E676).withOpacity(0.15), const Color(0xFF00E676))),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard("1", "Sold", const Color(0xFF1E293B), const Color(0xFF94A3B8))),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard("1,420", "Total Views", const Color(0xFF2F80ED).withOpacity(0.1), const Color(0xFF2F80ED))),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Active Scrollable Inventory Node Stream
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            physics: const BouncingScrollPhysics(),
            itemCount: listings.length,
            itemBuilder: (context, idx) {
              final item = listings[idx];
              
              // Safe fallbacks for models without active image paths
              final bool hasImage = item.images != null && 
                                    (item.images as List).isNotEmpty && 
                                    item.images[0] != null;

              // Mock interactive user engagement metrics array configuration
              final int mockViews = 120 + (idx * 111);
              final int mockChats = 5 + (idx * 9);
              final int mockLikes = 3 + (idx * 4);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1527), // Cyber deep card background
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF151D30)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Embedded Thumb Feature Graphic Container Frame
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF151D30),
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(hasImage ? item.images[0] : 'https://via.placeholder.com/150'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF070B19).withOpacity(0.75),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Active",
                              style: TextStyle(color: Color(0xFF00E676), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Detail Stack Node Layer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title ?? 'Equipment Post',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16, 
                              color: Colors.white,
                              letterSpacing: -0.2
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "ETB ${item.price ?? '0'}",
                            style: const TextStyle(
                              color: Color(0xFF00E676), 
                              fontWeight: FontWeight.w900, 
                              fontSize: 17
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Cameras • Posted May 18, 2026",
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 14),
                          
                          // Social Metrics Row Bar
                          Row(
                            children: [
                              _buildEngagementNode(Icons.visibility_outlined, mockViews.toString()),
                              const SizedBox(width: 16),
                              _buildEngagementNode(Icons.chat_bubble_outline_rounded, mockChats.toString()),
                              const SizedBox(width: 16),
                              _buildEngagementNode(Icons.favorite_border_rounded, mockLikes.toString()),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Horizontal Metric Counter Cards Box Builder Layout Component
  Widget _buildMetricCard(String value, String label, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1527),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF151D30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textCol),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// Compact Social Engagement Footer Node Component
  Widget _buildEngagementNode(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF2F80ED)),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(color: Color(0xFF2F80ED), fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// Premium Form System Sheet Overlay
  void _showPostItemSheet(BuildContext context) {
    _titleController.clear();
    _priceController.clear();
    _categoryController.clear();
    _descriptionController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0D1527),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 42, height: 5, decoration: BoxDecoration(color: const Color(0xFF151D30), borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Deploy Secure Post",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildFieldLabel("EQUIPMENT ASSIGNMENT"),
                    _buildModalTextField("Listing Title", _titleController),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("VALUATION (ETB)"),
                              _buildModalTextField("Price", _priceController, keyboardType: TextInputType.number),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("CATEGORY"),
                              _buildModalTextField("e.g., Cameras", _categoryController),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    _buildFieldLabel("SPECIFICATIONS"),
                    _buildModalTextField("Description details...", _descriptionController, maxLines: 3),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
                            return;
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E676),
                          foregroundColor: const Color(0xFF070B19),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text("Publish Listing Live 🚀", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF64748B), letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildModalTextField(String hint, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF070B19),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF151D30))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF151D30))),
      ),
    );
  }
}