import 'package:flutter/material.dart';
import '../widgets/sub_screen_header.dart'; // We will create this header widget below

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SubScreenHeader(title: "Markets", subtitle: "Browse categories"),
        Expanded(
          child: Center(
            child: Icon(Icons.storefront_outlined, size: 80, color: Colors.grey[200]),
          ),
        ),
      ],
    );
  }
}