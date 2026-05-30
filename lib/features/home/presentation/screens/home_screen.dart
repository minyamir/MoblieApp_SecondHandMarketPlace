import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../listings/presentation/provider/listings_provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListingsProvider>().loadListings();
    });
  }

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const _HomeDashboardContent(),
      MarketScreen(),  
      const TradeScreen(),    
      const MyListingsScreen(), 
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF070B19), // Match dark canvas backdrop layout
      body: SafeArea(
        child: Column(
          children: [
            const _TopStatusBadgeBar(),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF090E1A),
        border: Border(top: BorderSide(color: Color(0xFF151C2C), width: 1)),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF090E1A),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF00E676),
        unselectedItemColor: const Color(0xFF334155),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        onTap: _navigateToTab,
        items: [
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.home_filled, size: 26),
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.business_center_outlined, size: 26),
            ),
            label: 'Market',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.swap_horizontal_circle_outlined, size: 26),
            ),
            label: 'Trades',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.storefront_outlined, size: 26),
            ),
            label: 'Listings',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.person_outline_rounded, size: 26),
            ),
            label: 'Identity',
          ),
        ],
      ),
    );
  }
}

/// Top Status Pill Component
class _TopStatusBadgeBar extends StatelessWidget {
  const _TopStatusBadgeBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00E676).withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00E676).withOpacity(0.3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.verified_user_outlined, color: Color(0xFF00E676), size: 12),
                SizedBox(width: 4),
                Text("ሀሁ Market", style: TextStyle(color: Color(0xFF00E676), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Row(
            children: [
              Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle)),
              const SizedBox(width: 3),
              Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle)),
              const SizedBox(width: 3),
              Container(width: 18, height: 10, decoration: BoxDecoration(border: Border.all(color: Colors.white54), borderRadius: BorderRadius.circular(2))),
            ],
          )
        ],
      ),
    );
  }
}

/// Core Dashboard Body View
class _HomeDashboardContent extends StatelessWidget {
  const _HomeDashboardContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Panel Row
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("GOOD MORNING", style: TextStyle(color: Color(0xFF475569), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                    SizedBox(height: 6),
                    Text("Bereket Alemu", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(color: Color(0xFF00E676), shape: BoxShape.circle),
                        child: const Text("3", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          // Three Metric Cards Row
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.shield_outlined,
                    iconColor: Color(0xFF00E676),
                    value: "47,312",
                    label: "Verified Users",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.layers_outlined,
                    iconColor: Color(0xFF2F80ED),
                    value: "12,840",
                    label: "Active Listings",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: Color(0xFFF2994A),
                    value: "8.4M",
                    label: "ETB in Escrow",
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Trade Volume Chart Component
          const _TradeVolumeGraphCard(),

          const SizedBox(height: 28),
          
          // Section Heading Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Top Rated Equipment", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                ),
                Row(
                  children: const [
                    Text("See all", style: TextStyle(color: Color(0xFF00E676), fontSize: 15, fontWeight: FontWeight.w600)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF00E676), size: 12),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          const _FeaturedToolsHorizontalList(),

          const SizedBox(height: 24),
          const _PlatformServicesShowcase(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

/// UI Component: Metrics Sub-Card
class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1527), 
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF151D30), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.06), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(color: iconColor, fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(color: Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          )
        ],
      ),
    );
  }
}

/// UI Component: Custom Graph Card
class _TradeVolumeGraphCard extends StatelessWidget {
  const _TradeVolumeGraphCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1527),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF151D30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Trade Volume", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Nov 2025 — May 2026", style: TextStyle(color: Color(0xFF475569), fontSize: 12)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFF00E676).withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: const [
                    Icon(Icons.trending_up_rounded, color: Color(0xFF00E676), size: 14),
                    SizedBox(width: 4),
                    Text("+35.5%", style: TextStyle(color: Color(0xFF00E676), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: CustomPaint(painter: _ChartLinePainter()),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Dec", style: TextStyle(color: Color(0xFF475569), fontSize: 11)),
              Text("Jan", style: TextStyle(color: Color(0xFF475569), fontSize: 11)),
              Text("Feb", style: TextStyle(color: Color(0xFF475569), fontSize: 11)),
              Text("Mar", style: TextStyle(color: Color(0xFF475569), fontSize: 11)),
              Text("Apr", style: TextStyle(color: Color(0xFF475569), fontSize: 11)),
              Text("May", style: TextStyle(color: Color(0xFF475569), fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }
}

class _ChartLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF00E676)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [const Color(0xFF00E676).withOpacity(0.12), const Color(0xFF00E676).withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, size.height * 0.75);
    path.cubicTo(size.width * 0.35, size.height * 0.70, size.width * 0.65, size.height * 0.50, size.width, size.height * 0.20);

    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// UI Component: Clean Horizontal Equipment Slider
class _FeaturedToolsHorizontalList extends StatelessWidget {
  const _FeaturedToolsHorizontalList();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingsProvider>();

    if (provider.isLoading && provider.listings.isEmpty) {
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E676))));
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: provider.listings.isEmpty ? 3 : provider.listings.length,
        itemBuilder: (context, index) {
          final title = provider.listings.isEmpty ? "Heavy Drill" : provider.listings[index].title;
          final price = provider.listings.isEmpty ? "1,200" : "${provider.listings[index].price}";

          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1527),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF151D30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151D30),
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/150'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text("$price ETB", style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Bottom Features Showcase (Why Choose Us) - Fixed explicit cast issues
class _PlatformServicesShowcase extends StatelessWidget {
  const _PlatformServicesShowcase();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {"icon": Icons.gpp_good_rounded, "title": "AI Identity Check", "desc": "National ID & biometric user validation verification flow."},
      {"icon": Icons.account_balance_wallet_rounded, "title": "Secure Escrow Wallet", "desc": "Safe asset protection secure fund storage options."}
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: services.map((srv) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1527),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF151D30)),
            ),
            child: Row(
              children: [
                Icon(srv["icon"] as IconData, color: const Color(0xFF00E676), size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        srv["title"] as String, // 👈 FIXED: Explicitly casted to String
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        srv["desc"] as String, // 👈 FIXED: Explicitly casted to String
                        style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
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