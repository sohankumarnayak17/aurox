import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _transactionType = 'Expense'; // Options: 'Expense', 'Income'
  String _selectedCategory = 'Food';

  final List<String> _expenseCategories = ['Food', 'Shopping', 'Transport', 'Bills', 'Other'];
  final List<String> _incomeCategories = ['Salary', 'Freelance', 'Investment', 'Gift'];

  Future<void> _saveTransaction() async {
    if (_amountController.text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('transactions').add({
      'userId': user.uid,
      'amount': double.parse(_amountController.text),
      'type': _transactionType.toLowerCase(), // stored as 'income' or 'expense'
      'category': _selectedCategory,
      'description': _descriptionController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _amountController.clear();
    _descriptionController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction Added!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(title: const Text('Add Transaction', style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Type Switcher
            Row(
              children: [
                _typeTab('Expense', Colors.redAccent),
                _typeTab('Income', Colors.greenAccent),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 28),
              decoration: const InputDecoration(hintText: '0.00', hintStyle: TextStyle(color: Colors.white24), prefixText: '\$ '),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              dropdownColor: const Color(0xFF161616),
              style: const TextStyle(color: Colors.white),
              items: (_transactionType == 'Expense' ? _expenseCategories : _incomeCategories)
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Text('Save Transaction', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _typeTab(String label, Color color) {
    bool active = _transactionType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _transactionType = label;
          _selectedCategory = label == 'Expense' ? 'Food' : 'Salary';
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: active ? color.withOpacity(0.2) : Colors.transparent,
            border: Border.all(color: active ? color : Colors.white10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(label, style: TextStyle(color: active ? color : Colors.white54))),
        ),
      ),
    );
  }
}