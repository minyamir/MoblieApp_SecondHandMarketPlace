import 'package:flutter/material.dart';
import '../widgets/sub_screen_header.dart';

class TradeScreen extends StatelessWidget {
  const TradeScreen({super.key});

  // Local mock database array to safely populate our custom design cards
  final List<Map<String, dynamic>> mockTrades = const [
    {
      "id": "TX-9082",
      "title": "Makita HR2630 Rotary Hammer",
      "price": "12,500 ETB",
      "image": "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=150",
      "status": "AWAITING ESCROW",
      "statusColor": Color(0xFFFF9900),
      "statusBg": Color(0xFFFFF5E6),
      "isBuying": true,
      "party": "Seller: Abebe K."
    },
    {
      "id": "TX-4412",
      "title": "DeWalt Cordless Drill 18V",
      "price": "9,200 ETB",
      "image": "https://images.unsplash.com/photo-1581147036324-c17da42fe5a8?w=150",
      "status": "IN TRANSIT",
      "statusColor": Color(0xFF0052CC),
      "statusBg": Color(0xFFE8F0FE),
      "isBuying": true,
      "party": "Seller: Chala T."
    },
    {
      "id": "TX-1109",
      "title": "Bosch Professional Angle Grinder",
      "price": "7,800 ETB",
      "image": "https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=150",
      "status": "COMPLETED",
      "statusColor": Colors.green,
      "statusBg": Color(0xFFE6F4EA),
      "isBuying": false,
      "party": "Buyer: Helen S."
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Filter down our map sets cleanly based on context roles
    final buyingTrades = mockTrades.where((t) => t["isBuying"] == true).toList();
    final sellingTrades = mockTrades.where((t) => t["isBuying"] == false).toList();

    // DefaultTabController automatically binds TabBar and TabBarView seamlessly!
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        body: Column(
          children: [
            const SubScreenHeader(
              title: "Trade Studio", 
              subtitle: "Track, negotiate, and verify secure escrow deals"
            ),

            // Premium Segment Switcher Tabs Bar Card Frame
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                labelColor: const Color(0xFF0052CC),
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                tabs: const [
                  Tab(text: "Purchases"),
                  Tab(text: "Sales Operations"),
                ],
              ),
            ),

            // Main View Switcher Pipeline Frame
            Expanded(
              child: TabBarView(
                children: [
                  buyingTrades.isEmpty ? _buildEmptyState() : _buildTradeList(context, buyingTrades),
                  sellingTrades.isEmpty ? _buildEmptyState() : _buildTradeList(context, sellingTrades),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gorgeous Active Content Card List Builder
  Widget _buildTradeList(BuildContext context, List<Map<String, dynamic>> trades) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      physics: const BouncingScrollPhysics(),
      itemCount: trades.length,
      itemBuilder: (context, idx) {
        final trade = trades[idx];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Tracking Code ID & Verified Status Pill Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trade["id"] as String,
                    style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: trade["statusBg"] as Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      trade["status"] as String,
                      style: TextStyle(color: trade["statusColor"] as Color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.3),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: Color(0xFFF1F5F9)),
              ),

              // Row 2: Tool Thumb Image Layout & Info Details Block
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(trade["image"] as String),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trade["title"] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trade["party"] as String,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          trade["price"] as String,
                          style: const TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Row 3: Interactive Action Execution Buttons Layer
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _openDealTracking(context, trade["id"] as String),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("View Details", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _openChatHub(context, trade["id"] as String),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052CC).withOpacity(0.08),
                        foregroundColor: const Color(0xFF0052CC),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("Secure Chat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  /// Original Minimalist Empty State Placeholder
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                  )
                ],
              ),
              child: const Icon(
                Icons.swap_horizontal_circle_outlined, 
                size: 80, 
                color: Color(0xFF0052CC)
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "No Active Trades",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1D1E)
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "When you purchase or sell equipment via secure escrow networks, active pipelines live here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  void _openDealTracking(BuildContext context, String transactionId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Opening timeline log metrics for $transactionId...")),
    );
  }

  void _openChatHub(BuildContext context, String transactionId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Launching escrow negotiated chat for $transactionId...")),
    );
  }
}