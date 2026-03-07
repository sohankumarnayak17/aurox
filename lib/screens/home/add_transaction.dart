import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _transactionType = 'Expense';
  String _selectedCategory = 'Food';

  final List<String> _expenseCategories = [
    'Food', 'Shopping', 'Transport', 'Entertainment',
    'Bills', 'Healthcare', 'Education', 'Other',
  ];
  final List<String> _incomeCategories = [
    'Salary', 'Freelance', 'Investment', 'Gift', 'Other',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Add Transaction',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFF333333), width: 0.8),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: _typeButton(
                          'Expense', Icons.arrow_upward_rounded)),
                  Expanded(
                      child: _typeButton(
                          'Income', Icons.arrow_downward_rounded)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Amount',
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              decoration: InputDecoration(
                prefixText: '\$ ',
                prefixStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9E9E9E)),
                hintText: '0.00',
                hintStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333)),
                filled: true,
                fillColor: const Color(0xFF161616),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: Color(0xFF333333), width: 0.8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: Color(0xFF333333), width: 0.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: Colors.white, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Category',
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFF333333), width: 0.8),
              ),
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: const Color(0xFF161616),
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: Color(0xFF9E9E9E)),
                items: (_transactionType == 'Expense'
                        ? _expenseCategories
                        : _incomeCategories)
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Description',
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add a note...',
                hintStyle:
                    const TextStyle(color: Color(0xFF5C5C5C)),
                filled: true,
                fillColor: const Color(0xFF161616),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: Color(0xFF333333), width: 0.8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: Color(0xFF333333), width: 0.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: Colors.white, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (_amountController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '$_transactionType of \$${_amountController.text} added!'),
                        backgroundColor: _transactionType == 'Expense'
                            ? const Color(0xFFFF4D4D)
                            : const Color(0xFF4DFF9B),
                      ),
                    );
                    _amountController.clear();
                    _descriptionController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0D0D0D),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Add Transaction',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _typeButton(String type, IconData icon) {
    final isSelected = _transactionType == type;
    final color = type == 'Expense'
        ? const Color(0xFFFF4D4D)
        : const Color(0xFF4DFF9B);
    return GestureDetector(
      onTap: () => setState(() {
        _transactionType = type;
        _selectedCategory =
            type == 'Expense' ? 'Food' : 'Salary';
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.3)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? color : const Color(0xFF9E9E9E),
                size: 18),
            const SizedBox(width: 8),
            Text(type,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? color
                        : const Color(0xFF9E9E9E))),
          ],
        ),
      ),
    );
  }
}