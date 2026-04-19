import 'package:cloud_firestore/cloud_firestore.dart';

// ─────────────────────────────────────────────
//  TRANSACTION TYPE
// ─────────────────────────────────────────────
enum TransactionType { expense, income }

// ─────────────────────────────────────────────
//  TRANSACTION MODEL
//  File: lib/models/transaction_model.dart
// ─────────────────────────────────────────────
class TransactionModel {
  final String          id;
  final String          userId;
  final String          title;
  final String          category;
  final double          amount;
  final TransactionType type;
  final DateTime        date;
  final String?         note;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
  });

  // ── Helpers ───────────────────────────────
  bool get isExpense => type == TransactionType.expense;
  bool get isIncome  => type == TransactionType.income;

  String get typeString =>
      type == TransactionType.income ? 'income' : 'expense';

  String get formattedAmount =>
      '${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(2)}';

  // ── Firestore ─────────────────────────────
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id:       doc.id,
      userId:   d['userId']   ?? '',
      title:    d['title']    ?? '',
      category: d['category'] ?? '',
      amount:  (d['amount']   as num).toDouble(),
      type:     d['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date:    (d['date'] as Timestamp).toDate(),
      note:     d['note'],
    );
  }

  factory TransactionModel.fromMap(
      Map<String, dynamic> map, String id) {
    return TransactionModel(
      id:       id,
      userId:   map['userId']   ?? '',
      title:    map['title']    ?? '',
      category: map['category'] ?? '',
      amount:  (map['amount']   as num).toDouble(),
      type:     map['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date:     map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.parse(map['date'].toString()),
      note:     map['note'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId':   userId,
        'title':    title,
        'category': category,
        'amount':   amount,
        'type':     typeString,
        'date':     Timestamp.fromDate(date),
        if (note != null && note!.isNotEmpty) 'note': note,
      };

  Map<String, dynamic> toMap() => toFirestore();

  // ── Copy with ─────────────────────────────
  TransactionModel copyWith({
    String?          id,
    String?          userId,
    String?          title,
    String?          category,
    double?          amount,
    TransactionType? type,
    DateTime?        date,
    String?          note,
  }) {
    return TransactionModel(
      id:       id       ?? this.id,
      userId:   userId   ?? this.userId,
      title:    title    ?? this.title,
      category: category ?? this.category,
      amount:   amount   ?? this.amount,
      type:     type     ?? this.type,
      date:     date     ?? this.date,
      note:     note     ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'TransactionModel(id: $id, title: $title, '
      'amount: $amount, type: $typeString, date: $date)';
}