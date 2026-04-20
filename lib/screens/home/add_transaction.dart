import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey          = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController   = TextEditingController();
  String _type            = 'expense';
  String _category        = 'Food';
  bool   _saving          = false;

  final _expenseCategories = ['Food','Shopping','Transport','Entertainment','Bills','Healthcare','Education','Other'];
  final _incomeCategories  = ['Salary','Freelance','Investment','Gift','Other'];

  List<String> get _categories => _type == 'expense' ? _expenseCategories : _incomeCategories;

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

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
          content: Text(' of \UTF8{amount.toStringAsFixed(2)} added!'),
          backgroundColor: _type == 'expense' ? AppColors.expense : AppColors.income,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: '), backgroundColor: AppColors.expense),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('Add Transaction'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
              const SizedBox(height: 24),
              Text('Amount', style: AppTextStyles.label),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  prefixText: '\$ ',
                  prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textMuted),
                  hintText: '0.00',
                  hintStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.surfaceLight),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter an amount';
                  if (double.tryParse(v) == null) return 'Invalid number';
                  if (double.parse(v) <= 0) return 'Must be greater than 0';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text('Category', style: AppTextStyles.label),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle, width: 0.8),
                ),
                child: DropdownButton<String>(
                  value: _category,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: AppColors.surfaceDark,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ),
              const SizedBox(height: 24),
              Text('Description', style: AppTextStyles.label),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'Add a note...'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(width: 22, height: 22,
                          child: CircularProgressIndicator(color: AppColors.textOnCard, strokeWidth: 2))
                      : const Text('Add Transaction'),
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
    final color = type == 'expense' ? AppColors.expense : AppColors.income;
    return GestureDetector(
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
            Icon(icon, color: isSelected ? color : AppColors.textMuted, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                color: isSelected ? color : AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
