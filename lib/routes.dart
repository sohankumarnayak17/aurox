import 'package:flutter/material.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/home/homescreen.dart';
import 'screens/home/add_transaction.dart';
import 'screens/home/analytics.dart';
import 'screens/profile.dart';

class AppRoutes {
  AppRoutes._();
  static const String home     = '/home';
  static const String login    = '/login';
  static const String register = '/register';
  static const String addTx    = '/add-transaction';
  static const String analytics = '/analytics';
  static const String profile  = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:    return _fade(const LoginScreen(), settings);
      case register: return _fade(const RegisterScreen(), settings);
      case home:     return _fade(const HomeScreen(), settings);
      case addTx:    return _fade(const AddTransactionScreen(), settings);
      case analytics: return _fade(const AnalyticsScreen(), settings);
      case profile:  return _fade(const ProfileScreen(), settings);
      default:       return _fade(const HomeScreen(), settings);
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return _fade(const HomeScreen(), settings);
  }

  static PageRouteBuilder<T> _fade<T>(Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        child: child,
      ),
    );
  }
}
