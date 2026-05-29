import 'package:flutter/material.dart';
import '../../../home/presentation/widgets/sub_screen_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          // Elegant Custom Sub Header Widget
          const SubScreenHeader(
            title: "Identity Studio", 
            subtitle: "Manage security parameters and store configurations"
          ),
          
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  
                  // 1. PREMIUM PROFILE AVATAR WITH LIVE VERIFICATION RING
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(3.5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF0052CC), Color(0xFF22C55E)], // Blend brand blue to success green
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 54,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200'
                              ),
                            ),
                          ),
                        ),
                        // Live Escrow-Verified Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F4EA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade300, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_user_rounded, color: Colors.green.shade700, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                "KYC VERIFIED",
                                style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w900, fontSize: 9, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  const Text(
                    "Helen Solomon", 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -0.5)
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "helen.solomon@hahumarket.com", 
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)
                  ),
                  
                  const SizedBox(height: 28),
                  
                  // 2. LUXURY SECURITY WALLET METRIC PANEL
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 16, offset: const Offset(0, 6))
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ESCROW VAULT BALANCE", style: TextStyle(fontSize: 10, color: Colors.grey.shade400, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                              const SizedBox(height: 4),
                              const Text("38,450 ETB", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 40, color: Colors.grey.shade100),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("SECURED TRADES", style: TextStyle(fontSize: 10, color: Colors.grey.shade400, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                                const SizedBox(height: 4),
                                const Text("14 Active", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0052CC))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 28),
                  
                  // 3. ACCOUNT UTILITY SETTINGS HUB
                  _buildHubSectionTitle("SECURITY & COMPLIANCE"),
                  const SizedBox(height: 8),
                  _buildHubTile(
                    icon: Icons.admin_panel_settings_rounded,
                    iconColor: const Color(0xFF0052CC),
                    title: "Identity Vault & Biometrics",
                    subtitle: "Manage National ID and facial verification keys",
                    onTap: () {},
                  ),
                  _buildHubTile(
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: Colors.amber.shade800,
                    title: "Linked Settlement Accounts",
                    subtitle: "Manage bank configurations and Telebirr nodes",
                    onTap: () {},
                  ),
                  _buildHubTile(
                    icon: Icons.history_edu_rounded,
                    iconColor: Colors.purple.shade600,
                    title: "Escrow Ledger History",
                    subtitle: "Review end-to-end continuous transaction records",
                    onTap: () {},
                  ),
                  
                  const SizedBox(height: 20),
                  _buildHubSectionTitle("PREFERENCES"),
                  const SizedBox(height: 8),
                  _buildHubTile(
                    icon: Icons.notifications_active_rounded,
                    iconColor: Colors.blue.shade600,
                    title: "Deal & Trade Alert Tones",
                    subtitle: "Configure real-time offer push preferences",
                    onTap: () {},
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 4. CLEAN OUTLINED DANGER ZONE SYSTEM LOGOUT BUTTON
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Implement clear authorization session wipe pipeline safely here
                      },
                      icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 18),
                      label: const Text("Terminate Session", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.withOpacity(0.2), width: 1.5),
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.red.withOpacity(0.01),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Structural Title Layout Separator Helper Method
  Widget _buildHubSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.grey.shade400, letterSpacing: 0.8),
        ),
      ),
    );
  }

  /// High-End Container Action Card Option Tile
  Widget _buildHubTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade300, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}