import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          double inc = 0, exp = 0;
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            if (data['type'] == 'income') inc += data['amount'];
            else exp += data['amount'];
          }

          return Column(
            children: [
              const SizedBox(height: 60),
              const Text("Spending Analysis", style: TextStyle(color: Colors.white, fontSize: 20)),
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(value: inc, color: Colors.greenAccent, title: 'Income', radius: 50),
                      PieChartSectionData(value: exp, color: Colors.redAccent, title: 'Expense', radius: 50),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}