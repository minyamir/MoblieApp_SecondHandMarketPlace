import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // URL fallback example string -replace this with your dynamic state model pointer if needed (e.g., user.profileImageUrl)
    const String? profileImageUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400';

    return Scaffold(
      backgroundColor: const Color(0xFF070B19), //. Dark background matching HaHu ecosystem design
      body: SafeArea(
        child: Column(
          children: [
            // Top Action Settings Icon Row Frame
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D1527),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Color(0xFF64748B),
                    size: 22,
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HAHA MARKET SIGNATURE PROFILE IMAGE / INITIALS AVATAR FRAME
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E676).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: profileImageUrl != null && profileImageUrl.isNotEmpty
                                    ? Image.network(
                                        profileImageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => _buildInitialsPlaceholder(),
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  : null,
                                              color: const Color(0xFF00E676),
                                              strokeWidth: 2,
                                            ),
                                          );
                                        },
                                      )
                                    : _buildInitialsPlaceholder(),
                              ),
                            ),
                            // Floating shield verification node anchor
                            Positioned(
                              bottom: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF070B19),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.verified_user_rounded,
                                  color: Color(0xFF00E676),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // User Identity Labels Matrix
GestureDetector(
  onTap: () {
    // Navigates using the setup configured in your main.routes block
    Navigator.pushNamed(context, '/verification');
  },
  behavior: HitTestBehavior.opaque, // Ensures the entire text layout area detects taps cleanly
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Bereket Alemu",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        "@bereket.alemu  •  Member since Jan 2025",
        style: TextStyle(
          color: Color(0xFF64748B),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  ),
),
                    const SizedBox(height: 16),

                    // 2. KYC VERIFIED RIBBON BADGE BUTTON
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E676).withOpacity(0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF00E676).withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_user_rounded, color: Color(0xFF00E676), size: 14),
                          const SizedBox(width: 6),
                          Text(
                            "KYC VERIFIED • GREEN BADGE",
                            style: TextStyle(
                              color: const Color(0xFF00E676).withOpacity(0.85),
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Star Rating Engagement Index
                    Row(
                      children: [
                        ...List.generate(4, (index) => const Icon(Icons.star_rounded, color: Color(0xFFF2C94C), size: 20)),
                        const Icon(Icons.star_border_rounded, color: Color(0xFF334155), size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "4.9",
                          style: TextStyle(color: Color(0xFFF2C94C), fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "(47 reviews)",
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 3. STATISTICAL MATRIX DASHBOARD CARDS
                    Row(
                      children: [
                        Expanded(child: _buildStatMiniCard("31", "Trades")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatMiniCard("18", "Sold")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatMiniCard("13", "Bought")),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 4. PREVIEW ESCROW WALLET LAYER NODE
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1527),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF151D30)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF00E676).withOpacity(0.03),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00E676).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF00E676), size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "Escrow Wallet",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                              const Icon(Icons.visibility_outlined, color: Color(0xFF64748B), size: 20),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "AVAILABLE BALANCE",
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w900, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "ETB 91,000",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF00E676)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // 5. SECURE INTEGRATED PAYMENT NODES LIST
                    const Text(
                      "Payment Nodes",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 16),

                    _buildPaymentNodeTile(
                      logoIcon: Icons.phone_android_rounded,
                      logoBgColor: const Color(0xFFFFB300).withOpacity(0.1),
                      logoColor: const Color(0xFFFFB300),
                      title: "TeleBirr",
                      subtitle: "+251 91 234 5678 • Linked",
                      isActive: true,
                    ),

                    _buildPaymentNodeTile(
                      logoIcon: Icons.account_balance_rounded,
                      logoBgColor: const Color(0xFF2F80ED).withOpacity(0.1),
                      logoColor: const Color(0xFF2F80ED),
                      title: "Commercial Bank of Ethiopia",
                      subtitle: "****7342 • Linked",
                      isActive: true,
                    ),

                    const SizedBox(height: 8),

                    // Add Custom Verification Payment Gateway Button Link
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 18, color: Color(0xFF64748B)),
                      label: const Text(
                        "Add Payment Method", 
                        style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF151D30), style: BorderStyle.solid, width: 1.5),
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 6. DESTRUCTIVE ACTION SYSTEM DISMISSAL TERMINAL
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                      label: const Text(
                        "Sign Out", 
                        style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2A1518), width: 1.5),
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: const Color(0xFFEF4444).withOpacity(0.02),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Text Initials Placeholder Fallback Component
  Widget _buildInitialsPlaceholder() {
    return const Center(
      child: Text(
        "BA",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: Color(0xFF00E676),
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  /// Compact Analytics Numeric Matrix Block Component
  Widget _buildStatMiniCard(String count, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1527),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF151D30)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// Interactive Escrow Bank node connector panel item UI
  Widget _buildPaymentNodeTile({
    required IconData logoIcon,
    required Color logoBgColor,
    required Color logoColor,
    required String title,
    required String subtitle,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1527),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF151D30)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: logoBgColor, shape: BoxShape.circle),
            child: Icon(logoIcon, color: logoColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF00E676).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Active",
                style: TextStyle(color: Color(0xFF00E676), fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
