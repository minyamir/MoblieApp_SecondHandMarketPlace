import 'package:flutter/material.dart';

class TradeScreen extends StatelessWidget {
  const TradeScreen({super.key});

  // Upgraded live transaction state matrix data structure
  final List<Map<String, dynamic>> mockTrades = const [
    {
      "id": "TX-9082",
      "title": "Makita HR2630 Rotary Hammer",
      "price": "12,500",
      "status": "AWAITING ESCROW",
      "statusColor": Color(0xFFFF9900),
      "progress": 0.35,
      "milestone": "Waiting for buyer to fund vault lockup",
      "isBuying": true,
      "party": "Abebe K. (Seller)",
      "rating": "4.9",
    },
    {
      "id": "TX-4412",
      "title": "DeWalt Cordless Drill 18V",
      "price": "9,200",
      "status": "FUNDS LOCKED",
      "statusColor": Color(0xFF00E676),
      "progress": 0.70,
      "milestone": "Rider is delivering to drop-off station",
      "isBuying": true,
      "party": "Chala T. (Seller)",
      "rating": "4.8",
    },
    {
      "id": "TX-1109",
      "title": "Bosch Professional Angle Grinder",
      "price": "7,800",
      "status": "COMPLETED",
      "statusColor": Color(0xFF2F80ED),
      "progress": 1.0,
      "milestone": "Funds released to seller wallet",
      "isBuying": false,
      "party": "Helen S. (Buyer)",
      "rating": "5.0",
    }
  ];

  @override
  Widget build(BuildContext context) {
    final buyingTrades = mockTrades.where((t) => t["isBuying"] == true).toList();
    final sellingTrades = mockTrades.where((t) => t["isBuying"] == false).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF070B19), // Perfectly matches the Home Screen dark theme canvas
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom High-Fidelity Studio Header Frame
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("ESCROW PIPELINE", style: TextStyle(color: Color(0xFF00E676), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2.0)),
                          SizedBox(height: 6),
                          Text("Trade Studio", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFF0D1527), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF151D30))),
                        child: const Icon(Icons.tune_rounded, color: Color(0xFF00E676), size: 20),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Segmented Cyber Capsule Selector Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1527),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF151D30)),
              ),
              child: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: const Color(0xFF64748B),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.3),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: const Color(0xFF00E676), // High contrast neon brand interaction color
                  borderRadius: BorderRadius.circular(14),
                ),
                tabs: const [
                  Tab(text: "Incoming Orders"),
                  Tab(text: "Sales Channels"),
                ],
              ),
            ),

            // Main Active View Stack Pipeline
            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
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

  /// High Action Interactive Transaction Node Cards
  Widget _buildTradeList(BuildContext context, List<Map<String, dynamic>> trades) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      physics: const BouncingScrollPhysics(),
      itemCount: trades.length,
      itemBuilder: (context, idx) {
        final trade = trades[idx];
        
        // 🛠️ FIXED: Safe explicit casting expression priority layout
        final double progressValue = trade["progress"] as double;
        final int progressPercent = (progressValue * 100).toInt();

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1527),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: const Color(0xFF151D30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Layer: ID Badge + Status Capsule Glow Matrix
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          trade["id"] as String,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFF2994A), size: 14),
                          const SizedBox(width: 2),
                          Text(trade["rating"] as String, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: (trade["statusColor"] as Color).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: (trade["statusColor"] as Color).withOpacity(0.2)),
                    ),
                    child: Text(
                      trade["status"] as String,
                      style: TextStyle(color: trade["statusColor"] as Color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                  )
                ],
              ),
              
              const SizedBox(height: 16),

              // Item Title & Core Node Info Block
              Text(
                trade["title"] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white, letterSpacing: -0.3),
              ),
              const SizedBox(height: 4),
              Text(
                trade["party"] as String,
                style: const TextStyle(color: Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 20),

              // Live Milestone Pipeline Status Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF070B19),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: progressValue == 1.0 ? const Color(0xFF2F80ED) : const Color(0xFF00E676),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (progressValue == 1.0 ? const Color(0xFF2F80ED) : const Color(0xFF00E676)).withOpacity(0.4),
                            blurRadius: 6,
                            spreadRadius: 2,
                          )
                        ]
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        trade["milestone"] as String,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w500, height: 1.3),
                      ),
                    ),
                    Text(
                      "$progressPercent%",
                      style: TextStyle(color: trade["statusColor"] as Color, fontSize: 12, fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Horizontal Minimal Progress Slider Bar Component
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: const Color(0xFF151D30),
                  valueColor: AlwaysStoppedAnimation<Color>(trade["statusColor"] as Color),
                  minHeight: 4,
                ),
              ),

              const SizedBox(height: 20),

              // Price Tags & Action Nodes Grid Integration Layer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ESCROW LOCKED", style: TextStyle(color: Color(0xFF475569), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      const SizedBox(height: 2),
                      Text(
                        "${trade["price"]} ETB",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.2),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.chat_bubble_outline_rounded,
                        onTap: () => _openChatHub(context, trade["id"] as String),
                        color: const Color(0xFF00E676),
                      ),
                      const SizedBox(width: 10),
                      _buildActionButton(
                        icon: Icons.analytics_outlined,
                        onTap: () => _openDealTracking(context, trade["id"] as String),
                        color: const Color(0xFF2F80ED),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  /// Cyber Icon Button Helper Widget
  Widget _buildActionButton({required IconData icon, required VoidCallback onTap, required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  /// Gorgeous Minimal Dark Empty State Placeholder View Layout
  Widget _buildEmptyState() {
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
                color: Color(0xFF64748B)
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Locked Pipelines",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Active escrow contracts and hardware transactions you engage in will update live inside this node panel.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  void _openDealTracking(BuildContext context, String transactionId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0D1527),
        content: Text("Pulling ledger node records for $transactionId...", style: const TextStyle(color: Color(0xFF00E676))),
      ),
    );
  }

  void _openChatHub(BuildContext context, String transactionId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0D1527),
        content: Text("Connecting encrypted P2P channel for $transactionId...", style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}