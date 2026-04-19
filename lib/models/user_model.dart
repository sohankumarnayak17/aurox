import 'package:cloud_firestore/cloud_firestore.dart';

// ─────────────────────────────────────────────
//  USER MODEL
//  File: lib/models/user_model.dart
// ─────────────────────────────────────────────
class UserModel {
  final String    uid;
  final String    name;
  final String    email;
  final String?   photoUrl;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.createdAt,
  });

  // ── Helpers ───────────────────────────────
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  // ── Firestore ─────────────────────────────
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid:       doc.id,
      name:      d['name']      ?? '',
      email:     d['email']     ?? '',
      photoUrl:  d['photoUrl'],
      createdAt: d['createdAt'] != null
          ? (d['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid:       map['uid']      ?? '',
      name:      map['name']     ?? '',
      email:     map['email']    ?? '',
      photoUrl:  map['photoUrl'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'] != null
              ? DateTime.tryParse(map['createdAt'].toString())
              : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name':      name,
        'email':     email,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> toMap() => {
        'uid':       uid,
        'name':      name,
        'email':     email,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'createdAt': createdAt?.toIso8601String(),
      };

  // ── Copy with ─────────────────────────────
  UserModel copyWith({
    String?    uid,
    String?    name,
    String?    email,
    String?    photoUrl,
    DateTime?  createdAt,
  }) {
    return UserModel(
      uid:       uid       ?? this.uid,
      name:      name      ?? this.name,
      email:     email     ?? this.email,
      photoUrl:  photoUrl  ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid;

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() =>
      'UserModel(uid: $uid, name: $name, email: $email)';
}