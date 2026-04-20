import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  UserModel? _user;
  AuthStatus _status  = AuthStatus.unknown;
  bool       _loading = false;
  String?    _error;

  UserModel? get user      => _user;
  AuthStatus get status    => _status;
  bool       get isLoading => _loading;
  String?    get error     => _error;
  bool       get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        _user   = null;
        _status = AuthStatus.unauthenticated;
      } else {
        _user = UserModel(
          uid:       firebaseUser.uid,
          name:      firebaseUser.displayName ?? 'User',
          email:     firebaseUser.email ?? '',
          photoUrl:  firebaseUser.photoURL,
          createdAt: DateTime.now(),
        );
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await cred.user?.updateDisplayName(name);
      await _db.collection('users').doc(cred.user!.uid).set({
        'uid':       cred.user!.uid,
        'name':      name,
        'email':     email,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
      _error = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _mapError(e.code);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  String _mapError(String code) {
    switch (code) {
      case 'wrong-password':
      case 'invalid-credential':   return 'Incorrect email or password.';
      case 'user-not-found':       return 'No account found with this email.';
      case 'email-already-in-use': return 'Account already exists with this email.';
      case 'weak-password':        return 'Password must be at least 6 characters.';
      case 'network-request-failed': return 'Check your internet connection.';
      default:                     return 'Something went wrong. Please try again.';
    }
  }
}
