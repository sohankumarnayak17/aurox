import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

// ─────────────────────────────────────────────
//  CUSTOM WIDGETS
//  File: lib/widgets/common/custom_widgets.dart
// ─────────────────────────────────────────────

// ── 1. APP TEXT FIELD ─────────────────────────
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTextStyles.headingSmall),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscure,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          style: AppTextStyles.bodyLarge
              .copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon,
                    color: AppColors.textMuted, size: 20)
                : null,
            suffixIcon: widget.obscureText
                ? GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  )
                : widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: widget.onSuffixTap,
                        child: Icon(widget.suffixIcon,
                            color: AppColors.textMuted, size: 20),
                      )
                    : null,
          ),
        ),
      ],
    );
  }
}

// ── 2. AMOUNT INPUT FIELD ─────────────────────
class AmountTextField extends StatelessWidget {
  final TextEditingController controller;
  final String currencySymbol;
  final String? Function(String?)? validator;

  const AmountTextField({
    super.key,
    required this.controller,
    this.currencySymbol = '\$',
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.darkCard(radius: AppConstants.radiusMD),
      child: Row(
        children: [
          // Symbol box
          Container(
            width: 52,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppConstants.radiusMD),
              ),
            ),
            child: Center(
              child: Text(
                currencySymbol,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          // Number input
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: AppTextStyles.amountMedium,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: '0.00',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              validator: validator ??
                  (v) {
                    if (v == null || v.isEmpty) return 'Enter amount';
                    if (double.tryParse(v) == null) return 'Invalid number';
                    if (double.parse(v) <= 0) return 'Must be > 0';
                    return null;
                  },
            ),
          ),
        ],
      ),
    );
  }
}

// ── 3. PRIMARY BUTTON ─────────────────────────
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData? icon;
  final Color? color;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.icon,
    this.color,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.accent;
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: AppConstants.durationFast,
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: isLoading ? AppColors.surfaceLight : bg,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: AppColors.textOnCard, strokeWidth: 2),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon,
                          color: AppColors.textOnCard, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: AppTextStyles.headingSmall
                          .copyWith(color: AppColors.textOnCard),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── 4. OUTLINED BUTTON ────────────────────────
class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final double height;

  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.borderColor,
    this.textColor,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.borderSubtle;
    final text = textColor ?? AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(color: border, width: 1),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: text, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label,
                  style:
                      AppTextStyles.headingSmall.copyWith(color: text)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 5. SHIMMER LOADER ─────────────────────────
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 10,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            colors: [
              AppColors.surfaceLight,
              AppColors.surfaceMid,
              AppColors.surfaceLight,
            ],
            stops: [
              (_anim.value - 0.3).clamp(0.0, 1.0),
              _anim.value.clamp(0.0, 1.0),
              (_anim.value + 0.3).clamp(0.0, 1.0),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pre-built shimmer layout for transaction list
class TransactionListShimmer extends StatelessWidget {
  final int count;
  const TransactionListShimmer({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (_) => Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spaceMD, vertical: 5),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.darkCard(radius: AppConstants.radiusMD),
            child: Row(
              children: [
                const ShimmerBox(width: 46, height: 46, radius: 12),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 14),
                      const SizedBox(height: 8),
                      const ShimmerBox(width: 80, height: 10),
                    ],
                  ),
                ),
                const ShimmerBox(width: 60, height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 6. EMPTY STATE ────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusXL),
              ),
              child:
                  Icon(icon, color: AppColors.textMuted, size: 34),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: AppTextStyles.headingMedium,
                textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 160,
                child: AppButton(
                    label: actionLabel!, onTap: onAction, height: 46),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── 7. SECTION HEADER ─────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.headingMedium),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.accentSoft),
              ),
            ),
        ],
      ),
    );
  }
}

// ── 8. DIVIDER WITH LABEL ─────────────────────
class LabeledDivider extends StatelessWidget {
  final String label;
  const LabeledDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(color: AppColors.divider, thickness: 0.8)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: AppTextStyles.label),
        ),
        const Expanded(
            child: Divider(color: AppColors.divider, thickness: 0.8)),
      ],
    );
  }
}

// ── 9. ICON BUTTON ────────────────────────────
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: AppDecorations.darkCard(radius: AppConstants.radiusMD),
        child: Icon(icon,
            color: iconColor ?? AppColors.textSecondary, size: 22),
      ),
    );
  }
}

// ── 10. SNACK BAR HELPER ──────────────────────
class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline,
              color: isError ? AppColors.expense : AppColors.income,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Text(message, style: AppTextStyles.bodyMedium)),
          ],
        ),
        backgroundColor: AppColors.surfaceMid,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
      ),
    );
  }
}