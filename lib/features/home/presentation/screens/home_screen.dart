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
      _HomeDashboardContent(onNavigateToTab: _navigateToTab),
      MarketScreen(),  
      const TradeScreen(),    
      const MyListingsScreen(), 
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF070B19), 
      body: SafeArea(
        child: Column(
          children: [
            _TopStatusBadgeBar(onProfileTap: () => _navigateToTab(4)), 
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
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.home_filled, size: 26),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.business_center_outlined, size: 26),
            ),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.swap_horizontal_circle_outlined, size: 26),
            ),
            label: 'Trades',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.storefront_outlined, size: 26),
            ),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
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

/// Top Status Pill Component ...
class _TopStatusBadgeBar extends StatelessWidget {
  final VoidCallback onProfileTap;

  const _TopStatusBadgeBar({required this.onProfileTap});

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
                Text(
                  "ሀሁ Market", 
                  style: TextStyle(color: Color(0xFF00E676), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF00E676).withOpacity(0.4), 
                  width: 1.5,
                ),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF151D30),
                child: Icon(
                  Icons.person_outline, 
                  color: Colors.white70, 
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Core Dashboard Body View
class _HomeDashboardContent extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const _HomeDashboardContent({required this.onNavigateToTab});

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

          // Metric Cards Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
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
          const _TradeVolumeGraphCard(),
          const SizedBox(height: 28),
          
          // Section Heading: Featured Products
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Top Rated Equipment", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                ),
                GestureDetector(
                  onTap: () => onNavigateToTab(1), // Navigates to Market Screen
                  child: Row(
                    children: const [
                      Text("See all", style: TextStyle(color: Color(0xFF00E676), fontSize: 15, fontWeight: FontWeight.w600)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF00E676), size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          const _FeaturedToolsHorizontalList(),

          const SizedBox(height: 32),
          
          // NEW SECTION: How to use the App
          const _HowToUseSection(),

          const SizedBox(height: 32),

          // NEW SECTION: Value Props (Why Choose Me?)
          const _WhyChooseUsSection(),
          
          const SizedBox(height: 40),
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
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
        ),
      );
    }

    final int itemsCount = provider.listings.isEmpty ? 4 : provider.listings.length;

    return SizedBox(
      height: 210,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: itemsCount,
        itemBuilder: (context, index) {
          String title = "Market Item";
          String price = "0";
          String? resolvedUrl;

          if (provider.listings.isEmpty) {
            final List<Map<String, dynamic>> mockData = [
              {
                "title": "Sony A7III Mirrorless Ca...",
                "price": "ETB 42,500",
                "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=300",
              },
              {
                "title": "MacBook Pro M2 14\" 512...",
                "price": "ETB 87,000",
                "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=300",
              },
              {
                "title": "Pioneer HiFi Sound System",
                "price": "ETB 18,500",
                "image": "https://images.unsplash.com/photo-1545454675-3531b543be5d?w=300",
              },
              {
                "title": "Nikon D850 DSLR Kit",
                "price": "ETB 68,000",
                "image": "https://images.unsplash.com/photo-1606486668508-34636b2d2777?w=300",
              }
            ];
            
            title = mockData[index]["title"] as String;
            price = mockData[index]["price"] as String;
            resolvedUrl = mockData[index]["image"] as String;
          } else {
            final item = provider.listings[index];
            title = item.title ?? "Market Item";
            if (item.price != null) {
              price = item.price.toString().contains('ETB') ? "${item.price}" : "ETB ${item.price}";
            }
            if (item.images != null && item.images!.isNotEmpty) {
              resolvedUrl = item.images![0].toString();
            }
          }

          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1527),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF151D30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF151D30),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: resolvedUrl != null && resolvedUrl.startsWith('http')
                          ? Image.network(
                              resolvedUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildImageErrorView(),
                            )
                          : _buildImageErrorView(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(price, style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.w900, fontSize: 13)),
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

  Widget _buildImageErrorView() {
    return Container(
      color: const Color(0xFF151D30),
      child: Icon(Icons.broken_image_outlined, color: const Color(0xFF64748B).withOpacity(0.5), size: 24),
    );
  }
}

/// NEW UI COMPONENT: "How to Use" Step-by-Step Walkthrough
class _HowToUseSection extends StatelessWidget {
  const _HowToUseSection();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> steps = [
      {"step": "1", "title": "Verify Identity", "body": "Complete your biometric KYC check to become a verified trader."},
      {"step": "2", "title": "List or Browse Items", "body": "Post items for sale or search high-quality gear in the marketplace."},
      {"step": "3", "title": "Transact with Escrow", "body": "Funds stay locked safely in escrow until delivery is verified by both sides."}
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("How It Works", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
          const SizedBox(height: 16),
          ...steps.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF00E676),
                    child: Text(item["step"]!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["title"]!, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(item["body"]!, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.3)),
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

/// NEW UI COMPONENT: "Why Choose Us" Value Propositions
class _WhyChooseUsSection extends StatelessWidget {
  const _WhyChooseUsSection();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> perks = [
      {"icon": Icons.gpp_good_rounded, "title": "100% Peer Accountability", "desc": "No anonymous listings. Every user maps directly to an authenticated real-world identity check."},
      {"icon": Icons.account_balance_wallet_rounded, "title": "Secure Escrow Core", "desc": "Eliminate purchase anxiety. Payment is only dispatched upon successful product handoff."},
      {"icon": Icons.bolt_rounded, "title": "Zero Hidden Fees", "desc": "Transparent transaction fees built natively for local Ethiopian trade systems."}
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Why Choose ሀሁ Market?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
          const SizedBox(height: 16),
          ...perks.map((perk) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1527),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF151D30)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF00E676).withOpacity(0.06), shape: BoxShape.circle),
                    child: Icon(perk["icon"] as IconData, color: const Color(0xFF00E676), size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(perk["title"] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(perk["desc"] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.3)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
