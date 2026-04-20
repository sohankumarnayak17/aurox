import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
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
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    setState(() => _currentIndex = index);
    _pageController.animateToPage(index,
        duration: AppConstants.durationNormal, curve: AppConstants.curveSnappy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      drawer: AppDrawer(currentIndex: _currentIndex, onNavigate: _navigateTo),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) => setState(() => _currentIndex = i),
        children: const [
          _HomeTab(),
          AnalyticsScreen(),
          AddTransactionScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(current: _currentIndex, onTap: _navigateTo),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
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
                      decoration: AppDecorations.darkCard(radius: 14),
                      child: const Icon(Icons.menu_rounded,
                          color: AppColors.textSecondary, size: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Good morning',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      Text(user?.displayName ?? 'Shubh',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                    ],
                  ),
                ),
                Container(
                  width: 44, height: 44,
                  decoration: AppDecorations.darkCard(radius: 14),
                  child: const Icon(Icons.notifications_none_rounded,
                      color: AppColors.textSecondary, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _BalanceCard(userId: user?.uid ?? ''),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Transactions', style: AppTextStyles.headingSmall),
                Text('See all',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.accentSoft)),
              ],
            ),
            const SizedBox(height: 12),
            _RecentList(userId: user?.uid ?? ''),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String userId;
  const _BalanceCard({required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) return _card(0, 0, 0);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        double inc = 0, exp = 0;
        if (snapshot.hasData) {
          for (final doc in snapshot.data!.docs) {
            final d = doc.data() as Map<String, dynamic>;
            final amt = (d['amount'] as num?)?.toDouble() ?? 0;
            if (d['type'] == 'income') {
              inc += amt;
            } else {
              exp += amt;
            }
          }
        }
        return _card(inc - exp, inc, exp);
      },
    );
  }

  Widget _card(double bal, double inc, double exp) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: AppDecorations.darkCard(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Balance', style: AppTextStyles.label),
          const SizedBox(height: 6),
          Text('\$${bal.toStringAsFixed(2)}', style: AppTextStyles.amountLarge),
          const SizedBox(height: 20),
          Container(height: 0.8, color: AppColors.divider),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _stat('Income', inc, AppColors.income, Icons.arrow_downward_rounded)),
              Container(width: 0.8, height: 44, color: AppColors.divider),
              Expanded(child: _stat('Expense', exp, AppColors.expense, Icons.arrow_upward_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, double val, Color color, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.label),
            const SizedBox(height: 2),
            Text('\$${val.toStringAsFixed(2)}', style: AppTextStyles.headingSmall),
          ],
        ),
      ],
    );
  }
}

class _RecentList extends StatelessWidget {
  final String userId;
  const _RecentList({required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) return _empty();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(
                  color: AppColors.income, strokeWidth: 2),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _empty();
        return Column(
          children: snapshot.data!.docs.map((doc) {
            final d = doc.data() as Map<String, dynamic>;
            return _TxTile(data: d);
          }).toList(),
        );
      },
    );
  }

  Widget _empty() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.receipt_long_outlined,
              color: AppColors.textMuted, size: 40),
          const SizedBox(height: 12),
          Text('No transactions yet',
              style: AppTextStyles.headingSmall
                  .copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text('Add your first transaction', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  final Map<String, dynamic> data;
  const _TxTile({required this.data});

  static IconData _iconFor(String cat) {
    switch (cat.toLowerCase()) {
      case 'food':          return Icons.fastfood_outlined;
      case 'shopping':      return Icons.shopping_bag_outlined;
      case 'transport':     return Icons.directions_car_outlined;
      case 'entertainment': return Icons.headphones_outlined;
      case 'bills':         return Icons.receipt_long_outlined;
      case 'healthcare':    return Icons.favorite_outline_rounded;
      case 'education':     return Icons.school_outlined;
      case 'salary':        return Icons.account_balance_wallet_outlined;
      case 'freelance':     return Icons.work_outline_rounded;
      case 'investment':    return Icons.trending_up_rounded;
      case 'gift':          return Icons.card_giftcard_outlined;
      default:              return Icons.receipt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = data['type'] == 'income';
    final amount   = (data['amount'] as num?)?.toDouble() ?? 0;
    final category = data['category'] as String? ?? 'Other';
    final title    = data['description'] as String? ?? category;
    final ts       = data['date'];
    String dateStr = '';
    if (ts is Timestamp) {
      final d = ts.toDate();
      dateStr = '${d.day}/${d.month}/${d.year}';
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppDecorations.darkCard(radius: 14),
        child: Row(
          children: [
            Container(
              width: 46, height: 46,
              decoration: AppDecorations.transactionIcon,
              child: Icon(_iconFor(category),
                  color: AppColors.textSecondary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.headingSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusFull),
                        ),
                        child: Text(category, style: AppTextStyles.bodySmall),
                      ),
                      const SizedBox(width: 6),
                      Text(dateStr, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
              style: isIncome
                  ? AppTextStyles.amountIncome
                  : AppTextStyles.amountExpense,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.current, required this.onTap});

  static const _items = [
    (Icons.home_outlined,      Icons.home_rounded,       'Home'),
    (Icons.bar_chart_outlined, Icons.bar_chart_rounded,  'Analytics'),
    (Icons.add_circle_outline, Icons.add_circle_rounded, 'Add'),
    (Icons.person_outline,     Icons.person_rounded,     'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      height: AppConstants.bottomNavHeight + bottom,
      padding: EdgeInsets.only(bottom: bottom),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.8)),
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
                    duration: AppConstants.durationFast,
                    width: active ? 24 : 0,
                    height: 3,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  Icon(active ? activeIcon : icon,
                      color: active ? AppColors.textPrimary : AppColors.textMuted,
                      size: 22),
                  const SizedBox(height: 4),
                  Text(label,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: active ? AppColors.textPrimary : AppColors.textMuted)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
