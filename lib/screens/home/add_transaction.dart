import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/transaction_model.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey          = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController   = TextEditingController();
  String _type     = 'expense';
  String _category = 'Food';
  bool   _saving   = false;

  List<String> get _categories =>
      _type == 'expense'
          ? TransactionCategories.expense
          : TransactionCategories.income;

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showError('You must be logged in to add a transaction.');
      return;
    }

    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('transactions').add({
        'userId':      user.uid,
        'type':        _type,
        'amount':      amount,
        'category':    _category,
        'description': _descController.text.trim(),
        'date':        FieldValue.serverTimestamp(),
      });

      _amountController.clear();
      _descController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '${_type == 'expense' ? 'Expense' : 'Income'} of \$${amount.toStringAsFixed(2)} added!'),
          backgroundColor:
              _type == 'expense' ? AppColors.expense : AppColors.income,
        ));
      }
    } on FirebaseException catch (e) {
      _showError(e.message ?? 'Failed to save transaction.');
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.expense,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
          title: const Text('Add Transaction'),
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // â”€â”€ Type Toggle â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Semantics(
                label: 'Transaction type selector',
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _typeBtn('expense', 'Expense', Icons.arrow_upward_rounded)),
                      Expanded(child: _typeBtn('income',  'Income',  Icons.arrow_downward_rounded)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // â”€â”€ Amount â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Text('Amount', style: AppTextStyles.label),
              const SizedBox(height: 12),
              Semantics(
                label: 'Amount input field',
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700,
                        color: AppColors.textMuted),
                    hintText: '0.00',
                    hintStyle: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700,
                        color: AppColors.surfaceLight),
                  ),
                  validator: TransactionModel.validateAmount,
                ),
              ),
              const SizedBox(height: 24),

              // â”€â”€ Category â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Text('Category', style: AppTextStyles.label),
              const SizedBox(height: 12),
              Semantics(
                label: 'Category selector, currently $_category',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: AppColors.borderSubtle, width: 0.8),
                  ),
                  child: DropdownButton<String>(
                    value: _category,
                    isExpanded: true,
                    underline: const SizedBox(),
                    dropdownColor: AppColors.surfaceDark,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // â”€â”€ Description â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Text('Description', style: AppTextStyles.label),
              const SizedBox(height: 12),
              Semantics(
                label: 'Description input field',
                child: TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  maxLength: 200,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration:
                      const InputDecoration(hintText: 'Add a note...'),
                  validator: TransactionModel.validateDescription,
                ),
              ),
              const SizedBox(height: 32),

              // â”€â”€ Submit â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Semantics(
                button: true,
                label: 'Add transaction button',
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _submit,
                    child: _saving
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                                color: AppColors.textOnCard, strokeWidth: 2))
                        : const Text('Add Transaction'),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeBtn(String type, String label, IconData icon) {
    final isSelected = _type == type;
    final color =
        type == 'expense' ? AppColors.expense : AppColors.income;
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label transaction type',
      child: GestureDetector(
        onTap: () => setState(() {
          _type     = type;
          _category = type == 'expense' ? 'Food' : 'Salary';
        }),
        child: AnimatedContainer(
          duration: AppConstants.durationFast,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isSelected ? color : AppColors.textMuted, size: 18),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : AppColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}
