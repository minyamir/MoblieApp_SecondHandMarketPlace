import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../listings/presentation/provider/listings_provider.dart';
import '../widgets/sub_screen_header.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingsProvider>();
    final myOwnedListings = provider.listings;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          const SubScreenHeader(
            title: "Seller Studio", 
            subtitle: "Manage, track, and scale your tool listings"
          ),
          
          Expanded(
            child: provider.isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF0052CC)))
                : myOwnedListings.isEmpty
                    ? _buildEmptyState(context)
                    : _buildListingsInventory(context, myOwnedListings),
          ),
        ],
      ),
    );
  }

  /// Onboarding Placeholder for Empty State
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF0052CC).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.construction_rounded, 
                size: 72, 
                color: Color(0xFF0052CC)
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Your Workbench is Empty",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B)
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Turn your idle tools into cash. List them securely on HaHu Market with escrow protection.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => _showPostItemSheet(context),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text("Post an Item Now", style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052CC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Active Inventory Management Dashboard Layout
  Widget _buildListingsInventory(BuildContext context, List<dynamic> listings) {
    return Column(
      children: [
        // Premium Analytics Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatMetric("Active Live", listings.length.toString(), Colors.green),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              _buildStatMetric("In Trade", "1 Pending", const Color(0xFF0052CC)),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              _buildStatMetric("Escrow Earnings", "14.5K ETB", Colors.amber.shade800),
            ],
          ),
        ),

        // Action Toolbar Header Block
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Your Catalog", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 16)),
              InkWell(
                onTap: () => _showPostItemSheet(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0052CC).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.add_rounded, size: 16, color: Color(0xFF0052CC)),
                      SizedBox(width: 4),
                      Text("Add New", style: TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        
        // Active Custom Cards List Feed
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            physics: const BouncingScrollPhysics(),
            itemCount: listings.length,
            itemBuilder: (context, idx) {
              final item = listings[idx];
              final hasImage = item.images != null && item.images.isNotEmpty;
              
              final statusConfig = (idx % 3 == 0) 
                  ? {"label": "LIVE", "bg": const Color(0xFFE6F4EA), "text": Colors.green.shade700}
                  : (idx % 3 == 1)
                      ? {"label": "NEGOTIATING", "bg": const Color(0xFFE8F0FE), "text": const Color(0xFF0052CC)}
                      : {"label": "SOLD", "bg": Colors.grey.shade100, "text": Colors.grey.shade600};

              final Color badgeBgColor = statusConfig["bg"] as Color;
              final Color badgeTextColor = statusConfig["text"] as Color;

              return Dismissible(
                key: Key(item.id?.toString() ?? idx.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.delete_forever_rounded, color: Colors.white, size: 30),
                ),
                onDismissed: (direction) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${item.title ?? 'Listing'} unlisted safely")),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(18),
                          image: DecorationImage(
                            image: NetworkImage(hasImage ? item.images[0] : 'https://via.placeholder.com/150'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: badgeBgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusConfig["label"] as String,
                                style: TextStyle(color: badgeTextColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.title ?? 'Equipment Post',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${item.price ?? 0} ETB",
                              style: const TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.mode_edit_outline_rounded, color: Colors.grey, size: 20),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.bar_chart_rounded, color: Colors.grey, size: 20),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatMetric(String title, String val, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  /// PREMIUM WIZARD POST SYSTEM
  void _showPostItemSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 46, height: 6, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Deploy Secure Post", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.verified_user_rounded, color: Colors.green.shade600, size: 14),
                                const SizedBox(width: 4),
                                Text("Verified Creator Workspace", style: TextStyle(color: Colors.green.shade700, fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFF0052CC).withOpacity(0.06), shape: BoxShape.circle),
                          child: const Icon(Icons.gpp_good_rounded, color: Color(0xFF0052CC), size: 24),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    _buildFieldLabel("EQUIPMENT IMAGING"),
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FB),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF0052CC).withOpacity(0.15), width: 1.5),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
                                child: const Icon(Icons.add_a_photo_rounded, color: Color(0xFF0052CC), size: 28),
                              ),
                              const SizedBox(height: 12),
                              const Text("Upload Clear Tool Metrics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                              const SizedBox(height: 4),
                              Text("Include serial number or runtime specs if visible", style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildFieldLabel("EQUIPMENT ASSIGNMENT"),
                    _buildModalTextField("Listing Title (e.g., Bosch Professional Rotary Hammer GBH)"),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("ESCROW VALUATION"),
                              _buildModalTextField("Price (ETB)", keyboardType: TextInputType.number, prefixIcon: Icons.payments_outlined),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("HARDWARE CONDITION"),
                              _buildModalTextField("e.g., Like New / Used"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    _buildFieldLabel("DEEP REVIEW SPECIFICATIONS"),
                    _buildModalTextField("Provide a breakdown of performance issues, battery lifespan...", maxLines: 3),
                    const SizedBox(height: 20),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber.shade200.withOpacity(0.5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.shield_rounded, color: Colors.amber.shade800, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Escrow Protection Active", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber.shade900)),
                                const SizedBox(height: 2),
                                Text("Funds remain safe in the vault platform until the buyer physically verifies your equipment runtime.", style: TextStyle(fontSize: 11, color: Colors.amber.shade800, height: 1.4)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text("Post deployed live with verified escrow protection status!"),
                                ],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0052CC),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                        ),
                        child: const Text("Publish Under Escrow Protection 🚀", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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

  /// Structural Fixed Helper Method
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 13, 
          color: Color(0xFF1E293B)
        ),
      ),
    );
  }

  /// Unified Text Field Builder supporting Optional Prefix Icons
  Widget _buildModalTextField(String hint, {int maxLines = 1, TextInputType keyboardType = TextInputType.text, IconData? prefixIcon}) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: const Color(0xFF0052CC), size: 18) : null,
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}