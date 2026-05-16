import 'package:flutter/material.dart';
import '../widgets/sub_screen_header.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          // Consistent modern header
          const SubScreenHeader(
            title: "My Listings", 
            subtitle: "Manage your posted items"
          ),
          
          Expanded(
            child: Center(
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
                      Icons.format_list_bulleted_rounded, 
                      size: 80, 
                      color: Color(0xFF0052CC)
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No Listings Yet",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1D1E)
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Items you put up for sale will appear here.",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 25),
                  // "Amazing" Call to Action Button
                  ElevatedButton(
                    onPressed: () {
                      // Logic to add new listing
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0052CC),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("Post an Item", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}