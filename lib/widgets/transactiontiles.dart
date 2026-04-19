import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/transaction_model.dart';

// ─────────────────────────────────────────────
//  TRANSACTION TILE WIDGET
//  File: lib/widgets/transaction/transaction_tile.dart
// ─────────────────────────────────────────────

/// Full-size transaction tile used in lists
class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isExp = transaction.type == TransactionType.expense;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMD, vertical: 5),
      child: Dismissible(
        key: Key(transaction.id),
        direction: DismissDirection.endToStart,
        background: _DismissBackground(),
        confirmDismiss: (_) async {
          if (onDelete != null) {
            onDelete!();
            return false; // let the caller handle deletion
          }
          return false;
        },
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: AppDecorations.darkCard(radius: AppConstants.radiusMD),
            child: Row(
              children: [
                // ── Category Icon ────────────
                _TxIcon(category: transaction.category, isExpense: isExp),
                const SizedBox(width: 14),

                // ── Title + Date ─────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: AppTextStyles.headingSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _CategoryBadge(category: transaction.category),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('MMM d, h:mm a').format(transaction.date),
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Amount ───────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isExp ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                      style: isExp
                          ? AppTextStyles.amountExpense
                          : AppTextStyles.amountIncome,
                    ),
                    if (transaction.note != null &&
                        transaction.note!.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(Icons.notes_rounded,
                            size: 13, color: AppColors.textMuted),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact version — used in summary sections
class TransactionTileCompact extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionTileCompact({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExp = transaction.type == TransactionType.expense;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceMD, vertical: 4),
        child: Row(
          children: [
            _TxIcon(
                category: transaction.category,
                isExpense: isExp,
                size: 38),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.title,
                      style: AppTextStyles.headingSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(
                    DateFormat('MMM d').format(transaction.date),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              '${isExp ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
              style: isExp
                  ? AppTextStyles.amountExpense
                  : AppTextStyles.amountIncome,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  INTERNAL HELPERS
// ─────────────────────────────────────────────

class _TxIcon extends StatelessWidget {
  final String category;
  final bool isExpense;
  final double size;

  const _TxIcon({
    required this.category,
    required this.isExpense,
    this.size = 46,
  });

  static IconData _iconFor(String cat) {
    switch (cat.toLowerCase()) {
      case 'food':          return Icons.fastfood_outlined;
      case 'grocery':       return Icons.shopping_basket_outlined;
      case 'spotify':
      case 'entertainment': return Icons.headphones_outlined;
      case 'transport':     return Icons.directions_car_outlined;
      case 'health':        return Icons.favorite_outline_rounded;
      case 'shopping':      return Icons.shopping_bag_outlined;
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
    return Container(
      width: size,
      height: size,
      decoration: AppDecorations.transactionIcon,
      child: Icon(_iconFor(category),
          color: AppColors.textSecondary, size: size * 0.46),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(category, style: AppTextStyles.bodySmall),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppColors.expense.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(
            color: AppColors.expense.withOpacity(0.3), width: 0.8),
      ),
      child: const Icon(Icons.delete_outline_rounded,
          color: AppColors.expense, size: 22),
    );
  }
}