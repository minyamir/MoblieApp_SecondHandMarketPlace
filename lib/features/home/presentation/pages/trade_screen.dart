import 'package:flutter/material.dart';
import '../widgets/sub_screen_header.dart'; // Make sure you created this header widget earlier

class TradeScreen extends StatelessWidget {
  const TradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          // The attractive header we designed
          const SubScreenHeader(
            title: "Trade Center", 
            subtitle: "Manage your negotiations"
          ),
          
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Modern empty state illustration using icons
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
                  "When you start a trade, it will appear here.",
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}