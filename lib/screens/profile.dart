import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/colors.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('userId', isEqualTo: user?.uid ?? '')
            .snapshots(),
        builder: (context, snapshot) {
          double inc = 0, exp = 0;
          int txCount = 0;
          if (snapshot.hasData) {
            txCount = snapshot.data!.docs.length;
            for (final doc in snapshot.data!.docs) {
              final d = doc.data() as Map<String, dynamic>;
              final amt = (d['amount'] as num?)?.toDouble() ?? 0;
              if (d['type'] == 'income') { inc += amt; } else { exp += amt; }
            }
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // ── Avatar ─────────────────────
                Semantics(
                  label: 'User profile avatar for ${user?.displayName ?? 'Shubh'}',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: AppDecorations.darkCard(),
                    child: Column(
                      children: [
                        Container(
                          width: 72, height: 72,
                          decoration: const BoxDecoration(
                            gradient: AppColors.accentGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _initials(user?.displayName ?? 'S'),
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(user?.displayName ?? 'Shubh',
                            style: AppTextStyles.headingMedium),
                        const SizedBox(height: 4),
                        Text(user?.email ?? '',
                            style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Financial Summary ─────────────
                Semantics(
                  label: 'Financial summary card',
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppDecorations.darkCard(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Financial Summary', style: AppTextStyles.label),
                        const SizedBox(height: 14),
                        _row('Total Income',    '\$${inc.toStringAsFixed(2)}',  AppColors.income),
                        const SizedBox(height: 10),
                        _row('Total Expense',   '\$${exp.toStringAsFixed(2)}',  AppColors.expense),
                        Container(height: 0.8, color: AppColors.divider,
                            margin: const EdgeInsets.symmetric(vertical: 12)),
                        _row('Net Savings',
                            '\$${(inc - exp).toStringAsFixed(2)}',
                            (inc - exp) >= 0 ? AppColors.income : AppColors.expense),
                        const SizedBox(height: 10),
                        _row('Transactions', txCount.toString(), AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Menu ──────────────────────────
                Container(
                  decoration: AppDecorations.darkCard(),
                  child: Column(
                    children: [
                      _menuItem(context, Icons.person_outline,        'Edit Profile',    () {}),
                      _divider(),
                      _menuItem(context, Icons.settings_outlined,     'Settings',        () {}),
                      _divider(),
                      _menuItem(context, Icons.notifications_outlined,'Notifications',   () {}),
                      _divider(),
                      _menuItem(context, Icons.help_outline_rounded,  'Help & Support',  () {}),
                      _divider(),
                      _menuItem(context, Icons.logout_rounded,        'Logout', () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          AppRoutes.pushAndClearStack(context, AppRoutes.login);
                        }
                      }, color: AppColors.expense),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'S';
  }

  Widget _row(String label, String value, Color valueColor) {
    return Semantics(
      label: '$label: $value',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(value, style: AppTextStyles.headingSmall.copyWith(color: valueColor)),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label,
      VoidCallback onTap, {Color? color}) {
    final c = color ?? AppColors.textPrimary;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: (color ?? AppColors.textSecondary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: c, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(label,
                  style: AppTextStyles.headingSmall.copyWith(color: c))),
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => Container(
      height: 0.8, color: AppColors.divider,
      margin: const EdgeInsets.symmetric(horizontal: 16));
}
