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
          const SubScreenHeader(
            title: "My Profile", 
            subtitle: "Account settings"
          ),
          const SizedBox(height: 40),
          
          // Premium Profile Avatar (Static for now)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF0052CC), Color(0xFF4A90E2)],
              ),
            ),
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Icon(Icons.person_rounded, size: 70, color: Color(0xFF0052CC)),
            ),
          ),
          
          const SizedBox(height: 20),
          const Text("User Name", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("user@hahu.com", style: TextStyle(color: Colors.grey)),
          
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                // Logout logic later
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}