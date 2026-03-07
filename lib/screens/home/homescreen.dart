import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../widgets/common/app_drawer.dart';
import 'analytics.dart';
import 'add_transaction.dart';
import '../profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateTo(int index) {
    // Close drawer if open
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      drawer: AppDrawer(
        currentIndex: _currentIndex,
        onNavigate: _navigateTo,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // disable swipe — only tap nav
        onPageChanged: (i) => setState(() => _currentIndex = i),
        children: const [
          _HomeTab(),
          AnalyticsScreen(),
          AddTransactionScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        current: _currentIndex,
        onTap: _navigateTo,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Home Tab
// ─────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Builder(
                    builder: (ctx) => GestureDetector(
                      onTap: () => Scaffold.of(ctx).openDrawer(),
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: const Color(0xFF333333), width: 0.8),
                        ),
                        child: const Icon(Icons.menu_rounded,
                            color: Color(0xFF9E9E9E), size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good morning ☀️',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF5C5C5C))),
                        Text('Shubh',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF161616),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF333333), width: 0.8),
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Color(0xFF9E9E9E), size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF333333), width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Balance',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF5C5C5C),
                            letterSpacing: 0.8)),
                    const SizedBox(height: 6),
                    const Text('\$5,420.00',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.8)),
                    const SizedBox(height: 20),
                    Container(height: 0.8, color: const Color(0xFF2A2A2A)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _balanceStat(
                              'Income',
                              '\$3,200.00',
                              const Color(0xFF4DFF9B),
                              Icons.arrow_downward_rounded),
                        ),
                        Container(
                            width: 0.8,
                            height: 44,
                            color: const Color(0xFF2A2A2A)),
                        Expanded(
                          child: _balanceStat(
                              'Expense',
                              '\$1,780.00',
                              const Color(0xFFFF4D4D),
                              Icons.arrow_upward_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Transactions',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('See all',
                        style: TextStyle(
                            fontSize: 13, color: Color(0xFFD4D4D4))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _txTile('Spotify', 'Entertainment', '-\$15.00',
                  Icons.headphones_outlined, const Color(0xFFFF4D4D)),
              const SizedBox(height: 8),
              _txTile('Grocery', 'Food', '-\$150.00',
                  Icons.shopping_basket_outlined, const Color(0xFFFF4D4D)),
              const SizedBox(height: 8),
              _txTile('Salary', 'Income', '+\$3,200.00',
                  Icons.account_balance_wallet_outlined,
                  const Color(0xFF4DFF9B)),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _balanceStat(
      String label, String value, Color color, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF5C5C5C),
                    letterSpacing: 0.8)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _txTile(String title, String cat, String amount, IconData icon,
      Color amtColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF333333), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF9E9E9E), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 3),
                Text(cat,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF5C5C5C))),
              ],
            ),
          ),
          Text(amount,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: amtColor)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom Nav
// ─────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.current, required this.onTap});

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Analytics'),
    (Icons.add_circle_outline, Icons.add_circle_rounded, 'Add'),
    (Icons.person_outline, Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 72 + bottom,
      padding: EdgeInsets.only(bottom: bottom),
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
        border:
            Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 0.8)),
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final (icon, activeIcon, label) = _items[i];
          final active = current == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: active ? 24 : 0,
                    height: 3,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  Icon(active ? activeIcon : icon,
                      color: active
                          ? Colors.white
                          : const Color(0xFF5C5C5C),
                      size: 22),
                  const SizedBox(height: 4),
                  Text(label,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: active
                              ? Colors.white
                              : const Color(0xFF5C5C5C))),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}