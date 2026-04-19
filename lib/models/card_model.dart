import 'package:cloud_firestore/cloud_firestore.dart';

// ─────────────────────────────────────────────
//  CARD MODEL
//  File: lib/models/card_model.dart
// ─────────────────────────────────────────────
class CardModel {
  final String  id;
  final String  cardNumber;
  final String  cardHolder;
  final String  expiryDate;
  final double  balance;
  final String? userId;

  const CardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.balance,
    this.userId,
  });

  // ── Helpers ───────────────────────────────
  String get lastFour {
    final n = cardNumber.replaceAll(' ', '');
    return n.length >= 4 ? n.substring(n.length - 4) : n;
  }

  String get maskedNumber => '**** **** **** $lastFour';

  // ── Firestore ─────────────────────────────
  factory CardModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CardModel(
      id:          doc.id,
      cardNumber:  d['cardNumber']  ?? '',
      cardHolder:  d['cardHolder']  ?? '',
      expiryDate:  d['expiryDate']  ?? '',
      balance:    (d['balance']  as num?)?.toDouble() ?? 0.0,
      userId:      d['userId'],
    );
  }

  factory CardModel.fromMap(Map<String, dynamic> map, String id) {
    return CardModel(
      id:          id,
      cardNumber:  map['cardNumber']  ?? '',
      cardHolder:  map['cardHolder']  ?? '',
      expiryDate:  map['expiryDate']  ?? '',
      balance:    (map['balance'] as num?)?.toDouble() ?? 0.0,
      userId:      map['userId'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'cardNumber': cardNumber,
        'cardHolder': cardHolder,
        'expiryDate': expiryDate,
        'balance':    balance,
        if (userId != null) 'userId': userId,
      };

  Map<String, dynamic> toMap() => toFirestore();

  // ── Copy with ─────────────────────────────
  CardModel copyWith({
    String? id,
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
    double? balance,
    String? userId,
  }) {
    return CardModel(
      id:          id          ?? this.id,
      cardNumber:  cardNumber  ?? this.cardNumber,
      cardHolder:  cardHolder  ?? this.cardHolder,
      expiryDate:  expiryDate  ?? this.expiryDate,
      balance:     balance     ?? this.balance,
      userId:      userId      ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CardModel(id: $id, holder: $cardHolder, last4: $lastFour, balance: $balance)';
}