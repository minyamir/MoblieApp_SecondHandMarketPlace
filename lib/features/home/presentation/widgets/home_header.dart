import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. Give the header its own white card space with depth
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2. Top Section: Personalized Greeting & Profile
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Morning, 👋",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Text(
                    "HaHu Market",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900, // Extra bold for impact
                      color: Color(0xFF1A1D1E),
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              // Modern Avatar with Border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0052CC), width: 1.5),
                ),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFF0F5FF),
                  child: Icon(Icons.person_rounded, color: Color(0xFF0052CC)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // 3. The "Amazing" Search Bar
          // We use a Container with a custom shadow to make it "float"
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search anything...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0052CC), size: 28),
                
                // This Suffix Icon acts as a professional Filter button
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  width: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0052CC),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                ),
                
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}