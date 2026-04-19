import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/transaction_provider.dart';

// ─────────────────────────────────────────────
//  CHART WIDGETS
//  File: lib/widgets/charts/chart_widgets.dart
// ─────────────────────────────────────────────

// ── 1. DUAL BAR CHART (Expense + Income) ─────
/// Used on HomeScreen statistics section
class DualBarChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final double height;

  const DualBarChart({
    super.key,
    required this.data,
    this.height = AppConstants.chartHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text('No data available', style: AppTextStyles.bodyMedium),
        ),
      );
    }

    final maxVal = data
        .expand((d) => [d.expense, d.income])
        .fold(0.0, (a, b) => a > b ? a : b);

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: data.map((pt) {
          final eH = maxVal == 0
              ? 4.0
              : (pt.expense / maxVal * height).clamp(4.0, height);
          final iH = maxVal == 0
              ? 4.0
              : (pt.income / maxVal * height).clamp(4.0, height);

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _AnimBar(height: eH, color: AppColors.expense),
                  const SizedBox(width: 2),
                  _AnimBar(height: iH, color: AppColors.income),
                ],
              ),
              const SizedBox(height: 6),
              Text(pt.label, style: AppTextStyles.label),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── 2. SINGLE BAR CHART (one type) ───────────
/// Used on Analytics screen for filtered view
class SingleBarChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final bool showExpense;
  final double height;
  final bool showValueLabels;

  const SingleBarChart({
    super.key,
    required this.data,
    this.showExpense = true,
    this.height = AppConstants.chartHeight,
    this.showValueLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text('No data available', style: AppTextStyles.bodyMedium),
        ),
      );
    }

    final color = showExpense ? AppColors.expense : AppColors.income;
    final values =
        data.map((d) => showExpense ? d.expense : d.income).toList();
    final maxVal = values.fold(0.0, (a, b) => a > b ? a : b);

    return SizedBox(
      height: height + (showValueLabels ? 20 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(data.length, (i) {
          final val = values[i];
          final barH = maxVal == 0
              ? 4.0
              : (val / maxVal * height).clamp(4.0, height);

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showValueLabels && val > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '\$${val.toStringAsFixed(0)}',
                    style: AppTextStyles.label,
                  ),
                ),
              _AnimBar(
                height: barH,
                color: color,
                width: AppConstants.chartBarWidth,
              ),
              const SizedBox(height: 6),
              Text(data[i].label, style: AppTextStyles.label),
            ],
          );
        }),
      ),
    );
  }
}

// ── 3. MINI SPARKLINE ─────────────────────────
/// Thin line chart for compact overviews
class MiniSparkline extends StatelessWidget {
  final List<double> values;
  final Color color;
  final double height;
  final double width;

  const MiniSparkline({
    super.key,
    required this.values,
    this.color = AppColors.income,
    this.height = 40,
    this.width = 80,
  });

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) return SizedBox(width: width, height: height);
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SparklinePainter(values: values, color: color),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _SparklinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final minV = values.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV).clamp(1.0, double.infinity);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.25), color.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y = size.height -
          ((values[i] - minV) / range * size.height * 0.85) -
          size.height * 0.05;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ── 4. CATEGORY PROGRESS BAR ─────────────────
/// Animated bar showing category share of total
class CategoryProgressBar extends StatelessWidget {
  final String category;
  final double amount;
  final double percent;
  final Color color;

  const CategoryProgressBar({
    super.key,
    required this.category,
    required this.amount,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textPrimary),
            ),
            Text(
              '\$${amount.toStringAsFixed(2)} · ${(percent * 100).toStringAsFixed(0)}%',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          child: Stack(
            children: [
              Container(height: 6, color: AppColors.surfaceLight),
              AnimatedFractionallySizedBox(
                duration: AppConstants.durationSlow,
                curve: AppConstants.curveSnappy,
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
            ],
          ),
        ),
      ],
    );
  }
}

// ── 5. CHART LEGEND ───────────────────────────
class ChartLegend extends StatelessWidget {
  final List<_LegendItem> items;
  const ChartLegend({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: item.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(item.label, style: AppTextStyles.bodySmall),
                  ],
                ),
              ))
          .toList(),
    );
  }

  static ChartLegend dualBar() => ChartLegend(items: [
        _LegendItem(color: AppColors.expense, label: 'Expense'),
        _LegendItem(color: AppColors.income, label: 'Income'),
      ]);
}

class _LegendItem {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});
}

// ── 6. PERIOD TOGGLE ──────────────────────────
/// Week / Month toggle pill used above charts
class ChartPeriodToggle extends StatelessWidget {
  final String selected;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const ChartPeriodToggle({
    super.key,
    required this.selected,
    this.options = const ['Week', 'Month'],
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(color: AppColors.borderSubtle, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final active = opt == selected;
          return GestureDetector(
            onTap: () => onChanged(opt),
            child: AnimatedContainer(
              duration: AppConstants.durationFast,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: active
                  ? BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusFull),
                    )
                  : const BoxDecoration(),
              child: Text(
                opt,
                style: active
                    ? AppTextStyles.tabActive
                    : AppTextStyles.tabInactive,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── 7. STAT CARD ──────────────────────────────
/// Summary number card used in overview rows
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final List<double>? sparklineValues;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.sparklineValues,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.darkCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              if (sparklineValues != null)
                MiniSparkline(
                  values: sparklineValues!,
                  color: color,
                  width: 60,
                  height: 30,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: 4),
          Text(value,
              style: AppTextStyles.headingSmall,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  INTERNAL: ANIMATED BAR
// ─────────────────────────────────────────────
class _AnimBar extends StatelessWidget {
  final double height;
  final Color color;
  final double width;

  const _AnimBar({
    required this.height,
    required this.color,
    this.width = 10,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.durationSlow,
      curve: AppConstants.curveSnappy,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.chartBarRadius),
        ),
      ),
    );
  }
}