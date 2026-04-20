import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { expense, income }

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final String? note;
  final DateTime date;
  final String userId;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    this.note,
    required this.date,
    required this.userId,
  });

  bool get isExpense => type == TransactionType.expense;
  bool get isIncome  => type == TransactionType.income;
  double get signedAmount => isExpense ? -amount : amount;

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) return 'Amount is required';
    final n = double.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n <= 0) return 'Amount must be greater than zero';
    if (n > 10000000) return 'Amount is too large';
    return null;
  }

  static String? validateDescription(String? value) {
    if (value != null && value.length > 200) return 'Max 200 characters';
    return null;
  }

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id:       doc.id,
      title:    data['description'] as String? ?? data['category'] as String? ?? '',
      amount:   (data['amount'] as num).toDouble(),
      type:     data['type'] == 'income'
                  ? TransactionType.income
                  : TransactionType.expense,
      category: data['category'] as String,
      note:     data['description'] as String?,
      date:     (data['date'] as Timestamp).toDate(),
      userId:   data['userId'] as String,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title':       title,
    'amount':      amount,
    'type':        type == TransactionType.income ? 'income' : 'expense',
    'category':    category,
    'description': note ?? '',
    'date':        Timestamp.fromDate(date),
    'userId':      userId,
  };

  TransactionModel copyWith({
    String? id, String? title, double? amount, TransactionType? type,
    String? category, String? note, DateTime? date, String? userId,
  }) => TransactionModel(
    id:       id       ?? this.id,
    title:    title    ?? this.title,
    amount:   amount   ?? this.amount,
    type:     type     ?? this.type,
    category: category ?? this.category,
    note:     note     ?? this.note,
    date:     date     ?? this.date,
    userId:   userId   ?? this.userId,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is TransactionModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

class TransactionCategories {
  TransactionCategories._();

  static const List<String> expense = [
    'Food', 'Shopping', 'Transport', 'Entertainment',
    'Bills', 'Healthcare', 'Education', 'Other',
  ];

  static const List<String> income = [
    'Salary', 'Freelance', 'Investment', 'Gift', 'Other',
  ];

  static IconData iconFor(String category) {
    switch (category.toLowerCase()) {
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
}