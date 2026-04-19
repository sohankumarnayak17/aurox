import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/card_model.dart';

// ─────────────────────────────────────────────
//  WALLET CARD WIDGET
//  File: lib/widgets/wallet/wallet_card.dart
// ─────────────────────────────────────────────

/// Full payment card (white card from the design)
class WalletCard extends StatelessWidget {
  final CardModel card;
  final bool showBalance;
  final VoidCallback? onTap;

  const WalletCard({
    super.key,
    required this.card,
    this.showBalance = true,
    this.onTap,
  });

  String get _masked {
    final n = card.cardNumber.replaceAll(' ', '');
    if (n.length < 4) return n;
    return '**** **** **** ${n.substring(n.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppConstants.cardHeight,
        width: AppConstants.cardWidth,
        padding: const EdgeInsets.all(22),
        decoration: AppDecorations.whiteCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row: Chip + Brand ────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ChipIcon(),
                _BrandDots(),
              ],
            ),

            const Spacer(),

            // ── Balance (optional) ───────────
            if (showBalance) ...[
              Text('Current Balance', style: AppTextStyles.labelCaps),
              const SizedBox(height: 2),
              Text(
                '\$${card.balance.toStringAsFixed(2)}',
                style: AppTextStyles.cardNumber.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 12),
            ],

            // ── Card Number ──────────────────
            Text(_masked, style: AppTextStyles.cardNumber),
            const SizedBox(height: 14),

            // ── Holder + Expiry ──────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CardLabel(label: 'CARD HOLDER', value: card.cardHolder),
                _CardLabel(
                    label: 'EXPIRES',
                    value: card.expiryDate,
                    align: CrossAxisAlignment.end),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Smaller dark card variant for compact lists
class WalletCardSmall extends StatelessWidget {
  final CardModel card;
  final VoidCallback? onTap;

  const WalletCardSmall({super.key, required this.card, this.onTap});

  String get _lastFour {
    final n = card.cardNumber.replaceAll(' ', '');
    return n.length >= 4 ? '**** ${n.substring(n.length - 4)}' : n;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppDecorations.darkCard(),
        child: Row(
          children: [
            // Card icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSM),
              ),
              child: const Icon(Icons.credit_card_rounded,
                  color: AppColors.textSecondary, size: 22),
            ),
            const SizedBox(width: 14),

            // Number + Holder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_lastFour, style: AppTextStyles.headingSmall),
                  const SizedBox(height: 3),
                  Text(card.cardHolder, style: AppTextStyles.bodySmall),
                ],
              ),
            ),

            // Balance
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${card.balance.toStringAsFixed(2)}',
                    style: AppTextStyles.headingSmall),
                const SizedBox(height: 3),
                Text(card.expiryDate, style: AppTextStyles.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Carousel wrapper with PageView + dots
class WalletCardCarousel extends StatefulWidget {
  final List<CardModel> cards;
  final VoidCallback? onAddCard;

  const WalletCardCarousel({
    super.key,
    required this.cards,
    this.onAddCard,
  });

  @override
  State<WalletCardCarousel> createState() => _WalletCardCarouselState();
}

class _WalletCardCarouselState extends State<WalletCardCarousel> {
  int _active = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Cards', style: AppTextStyles.headingMedium),
              GestureDetector(
                onTap: widget.onAddCard,
                child: Text(
                  '+ Add Card',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.accentSoft),
                ),
              ),
            ],
          ),
        ),

        // Page view
        SizedBox(
          height: AppConstants.cardHeight,
          child: widget.cards.isEmpty
              ? _EmptyCardSlot(onTap: widget.onAddCard)
              : PageView.builder(
                  controller: PageController(viewportFraction: 0.88),
                  itemCount: widget.cards.length,
                  onPageChanged: (i) => setState(() => _active = i),
                  itemBuilder: (_, i) => AnimatedScale(
                    scale: _active == i ? 1.0 : 0.95,
                    duration: AppConstants.durationNormal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: WalletCard(card: widget.cards[i]),
                    ),
                  ),
                ),
        ),

        // Dots
        if (widget.cards.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.cards.length,
                (i) => AnimatedContainer(
                  duration: AppConstants.durationFast,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _active == i ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _active == i
                        ? AppColors.accent
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  INTERNAL HELPERS
// ─────────────────────────────────────────────

class _ChipIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 26,
      decoration: BoxDecoration(
        color: AppColors.surfaceMid.withOpacity(0.25),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _BrandDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        4,
        (i) => Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            color: AppColors.textOnCard.withOpacity(0.35),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment align;

  const _CardLabel({
    required this.label,
    required this.value,
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: AppTextStyles.labelCaps),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.cardHolder),
      ],
    );
  }
}

class _EmptyCardSlot extends StatelessWidget {
  final VoidCallback? onTap;
  const _EmptyCardSlot({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: AppConstants.cardHeight,
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            border: Border.all(
                color: AppColors.borderSubtle,
                width: 1,
                style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_card_outlined,
                  color: AppColors.textMuted, size: 36),
              const SizedBox(height: 10),
              Text('Add your first card',
                  style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}