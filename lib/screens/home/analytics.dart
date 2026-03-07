import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Analytics Screen', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
