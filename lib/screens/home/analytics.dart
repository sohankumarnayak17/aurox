import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _period = 'Month';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Analytics'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _PeriodToggle(
                selected: _period,
                onChanged: (p) => setState(() => _period = p)),
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: Text('Not logged in',
                  style: TextStyle(color: AppColors.textMuted)))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('transactions')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.income, strokeWidth: 2));
                }
                final docs = snapshot.data?.docs ?? [];
                final now = DateTime.now();
                final filtered = docs.where((doc) {
                  final d = doc.data() as Map<String, dynamic>;
                  final ts = d['date'];
                  if (ts == null) return false;
                  final date = (ts as Timestamp).toDate();
                  if (_period == 'Week') return now.difference(date).inDays <= 7;
                  if (_period == 'Month') {
                    return date.month == now.month && date.year == now.year;
                  }
                  return date.year == now.year;
                }).toList();

                double inc = 0, exp = 0;
                final Map<String, double> catMap = {};
                final Map<String, double> incMap = {};

                for (final doc in filtered) {
                  final d = doc.data() as Map<String, dynamic>;
                  final amt = (d['amount'] as num?)?.toDouble() ?? 0;
                  final cat = d['category'] as String? ?? 'Other';
                  final type = d['type'] as String? ?? 'expense';
                  if (type == 'income') {
                    inc += amt;
                    incMap[cat] = (incMap[cat] ?? 0) + amt;
                  } else {
                    exp += amt;
                    catMap[cat] = (catMap[cat] ?? 0) + amt;
                  }
                }

                final net = inc - exp;
                final savings = inc > 0 ? ((inc - exp) / inc).clamp(0.0, 1.0) : 0.0;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        _StatCard(label: 'Income', value: inc, color: AppColors.income, icon: Icons.arrow_downward_rounded),
                        const SizedBox(width: 10),
                        _StatCard(label: 'Expense', value: exp, color: AppColors.expense, icon: Icons.arrow_upward_rounded),
                        const SizedBox(width: 10),
                        _StatCard(label: 'Net', value: net, color: net >= 0 ? AppColors.income : AppColors.expense, icon: Icons.account_balance_outlined),
                      ]),
                      const SizedBox(height: 24),
                      Text('Expense Breakdown', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 12),
                      catMap.isEmpty
                          ? _emptyCard('No expense data for this period')
                          : _PieSection(data: catMap, total: exp),
                      const SizedBox(height: 24),
                      if (catMap.isNotEmpty) ...[
                        Text('Category Details', style: AppTextStyles.headingSmall),
                        const SizedBox(height: 12),
                        ...(catMap.entries.toList()
                              ..sort((a, b) => b.value.compareTo(a.value)))
                            .map((e) => _CatBar(
                                  category: e.key,
                                  amount: e.value,
                                  percent: exp > 0 ? e.value / exp : 0,
                                  color: _catColor(e.key),
                                )),
                        const SizedBox(height: 24),
                      ],
                      Text('Income Sources', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 12),
                      incMap.isEmpty
                          ? _emptyCard('No income data for this period')
                          : Column(
                              children: (incMap.entries.toList()
                                    ..sort((a, b) => b.value.compareTo(a.value)))
                                  .map((e) => _CatBar(
                                        category: e.key,
                                        amount: e.value,
                                        percent: inc > 0 ? e.value / inc : 0,
                                        color: AppColors.income,
                                      ))
                                  .toList(),
                            ),
                      const SizedBox(height: 24),
                      Text('Savings Rate', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 12),
                      _SavingsBar(rate: savings),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _emptyCard(String msg) => Container(
        padding: const EdgeInsets.all(20),
        decoration: AppDecorations.darkCard(),
        child: Center(child: Text(msg, style: AppTextStyles.bodyMedium)),
      );

  static Color _catColor(String cat) {
    const map = {
      'Food': Color(0xFFFF6B6B),
      'Shopping': Color(0xFFFFD93D),
      'Transport': Color(0xFF6BCB77),
      'Entertainment': Color(0xFF4D96FF),
      'Bills': Color(0xFFC77DFF),
      'Healthcare': Color(0xFFFF9F43),
      'Education': Color(0xFF54A0FF),
    };
    return map[cat] ?? const Color(0xFF9E9E9E);
  }
}

class _PeriodToggle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _PeriodToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceMid,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(color: AppColors.borderSubtle, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Week', 'Month', 'Year'].map((p) {
          final active = p == selected;
          return GestureDetector(
            onTap: () => onChanged(p),
            child: AnimatedContainer(
              duration: AppConstants.durationFast,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: active
                  ? BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusFull),
                    )
                  : const BoxDecoration(),
              child: Text(p,
                  style: active
                      ? AppTextStyles.tabActive
                      : AppTextStyles.tabInactive),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    final display =
        (value < 0 ? '-' : '') + '\$' + value.abs().toStringAsFixed(0);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: AppDecorations.darkCard(radius: AppConstants.radiusMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 14),
            ),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.label),
            const SizedBox(height: 2),
            Text(display,
                style: AppTextStyles.headingSmall
                    .copyWith(color: color, fontSize: 13),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _PieSection extends StatelessWidget {
  final Map<String, double> data;
  final double total;
  const _PieSection({required this.data, required this.total});

  static const _palette = [
    Color(0xFFFF6B6B), Color(0xFFFFD93D), Color(0xFF6BCB77),
    Color(0xFF4D96FF), Color(0xFFC77DFF), Color(0xFFFF9F43),
    Color(0xFF54A0FF), Color(0xFF9E9E9E),
  ];

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.darkCard(),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _PiePainter(entries, total, _palette),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total', style: AppTextStyles.label),
                    Text('\$${total.toStringAsFixed(0)}',
                        style: AppTextStyles.headingSmall),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12, runSpacing: 8,
            children: entries.asMap().entries.map((e) {
              final color = _palette[e.key % _palette.length];
              final pct = total > 0
                  ? (e.value.value / total * 100).toStringAsFixed(0)
                  : '0';
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 5),
                  Text('${e.value.key} $pct%', style: AppTextStyles.bodySmall),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<MapEntry<String, double>> data;
  final double total;
  final List<Color> palette;
  _PiePainter(this.data, this.total, this.palette);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 10;
    double start = -1.5707963;
    for (int i = 0; i < data.length; i++) {
      final sweep = total > 0 ? (data[i].value / total) * 6.2831853 : 0.0;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start, sweep, false,
        Paint()
          ..color = palette[i % palette.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 30
          ..strokeCap = StrokeCap.butt,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start + sweep - 0.04, 0.04, false,
        Paint()
          ..color = AppColors.surfaceDark
          ..style = PaintingStyle.stroke
          ..strokeWidth = 32,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_PiePainter old) => true;
}

class _CatBar extends StatelessWidget {
  final String category;
  final double amount;
  final double percent;
  final Color color;
  const _CatBar(
      {required this.category,
      required this.amount,
      required this.percent,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary)),
              Text(
                  '\$${amount.toStringAsFixed(2)}  ${(percent * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            child: Stack(children: [
              Container(height: 6, color: AppColors.surfaceLight),
              AnimatedFractionallySizedBox(
                duration: AppConstants.durationSlow,
                widthFactor: percent.clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SavingsBar extends StatelessWidget {
  final double rate;
  const _SavingsBar({required this.rate});

  @override
  Widget build(BuildContext context) {
    final color = rate >= 0.3
        ? AppColors.income
        : rate >= 0.1
            ? const Color(0xFFFFD93D)
            : AppColors.expense;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.darkCard(radius: AppConstants.radiusMD),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Saved ${(rate * 100).toStringAsFixed(0)}% of income',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary)),
              Text('${(rate * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.headingSmall.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            child: Stack(children: [
              Container(height: 8, color: AppColors.surfaceLight),
              AnimatedFractionallySizedBox(
                duration: AppConstants.durationSlow,
                widthFactor: rate,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}