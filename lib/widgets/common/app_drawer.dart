// lib/widgets/common/app_drawer.dart

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigate;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  static const _navItems = [
    (Icons.home_rounded, Icons.home_outlined, 'Home', 0),
    (Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Analytics', 1),
    (Icons.add_circle_rounded, Icons.add_circle_outline, 'Add Transaction', 2),
    (Icons.person_rounded, Icons.person_outline, 'Profile', 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF111111),
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4DFF9B), Color(0xFF00C9FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('shubh',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text('shubh@email.com',
                          style: TextStyle(fontSize: 11, color: Color(0xFF5C5C5C))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(height: 0.8, color: const Color(0xFF2A2A2A)),
            ),
            const SizedBox(height: 20),

            // Nav Items — tapping closes drawer and navigates
            ...List.generate(_navItems.length, (i) {
              final (activeIcon, icon, label, pageIndex) = _navItems[i];
              final isActive = currentIndex == pageIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onNavigate(pageIndex), // closes drawer + navigates
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF1E1E1E) : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isActive ? const Color(0xFF333333) : Colors.transparent,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isActive ? activeIcon : icon,
                            color: isActive ? const Color(0xFF4DFF9B) : const Color(0xFF5C5C5C),
                            size: 22,
                          ),
                          const SizedBox(width: 14),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                              color: isActive ? Colors.white : const Color(0xFF5C5C5C),
                            ),
                          ),
                          if (isActive) ...[
                            const Spacer(),
                            Container(
                              width: 6, height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4DFF9B),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(height: 0.8, color: const Color(0xFF2A2A2A)),
            ),
            const SizedBox(height: 8),

            _actionTile(
              icon: Icons.settings_outlined,
              label: 'Settings',
              color: const Color(0xFF5C5C5C),
              onTap: () => Navigator.of(context).pop(),
            ),
            _actionTile(
              icon: Icons.logout_rounded,
              label: 'Logout',
              color: const Color(0xFFFF4D4D),
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 14),
                Text(label, style: TextStyle(fontSize: 15, color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}