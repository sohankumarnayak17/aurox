import 'package:flutter/material.dart';

import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import '../screens/home/homescreen.dart';
import '../screens/home/add_transaction.dart';
import '../screens/home/analytics.dart';
import '../screens/profile.dart';

// ─────────────────────────────────────────────
//  APP ROUTES
//  File: lib/core/app_routes.dart
// ─────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  // ── Route Name Constants ──────────────────
  static const String splash      = '/';
  static const String login       = '/login';
  static const String register    = '/register';
  static const String home        = '/home';
  static const String addTx       = '/add-transaction';
  static const String analytics   = '/analytics';
  static const String profile     = '/profile';

  // ── Route Map (static fallback) ───────────
  static Map<String, WidgetBuilder> get routes => {
    login:      (_) => const LoginScreen(),
    register:   (_) => const RegisterScreen(),
    home:       (_) => const HomeScreen(),
    addTx:      (_) => const AddTransactionScreen(),
    analytics:  (_) => const AnalyticsScreen(),
    profile:    (_) => const ProfileScreen(),
  };

  // ─────────────────────────────────────────
  //  ON GENERATE ROUTE  (with transitions)
  // ─────────────────────────────────────────
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      // ── Auth ──────────────────────────────
      case login:
        return _fade(const LoginScreen(), settings);

      case register:
        return _slideRight(const RegisterScreen(), settings);

      // ── Main Shell ────────────────────────
      case home:
        return _fade(const HomeScreen(), settings);

      // ── Home sub-screens ──────────────────
      case addTx:
        return _slideUp(const AddTransactionScreen(), settings);

      case analytics:
        return _fade(const AnalyticsScreen(), settings);

      case profile:
        return _slideRight(const ProfileScreen(), settings);

      // ── Fallback ──────────────────────────
      default:
        return _fade(const LoginScreen(), settings);
    }
  }

  // ── Unknown Route Fallback ────────────────
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return _fade(
      _NotFoundScreen(routeName: settings.name ?? 'unknown'),
      settings,
    );
  }

  // ─────────────────────────────────────────
  //  NAVIGATION HELPERS  (call from anywhere)
  // ─────────────────────────────────────────

  /// Push a named route
  static void push(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// Push and remove all previous routes (used after login / logout)
  static void pushAndClearStack(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
        context, routeName, (route) => false);
  }

  /// Replace current route
  static void replace(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName,
        arguments: arguments);
  }

  /// Pop back
  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }

  /// Pop until a named route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  // ─────────────────────────────────────────
  //  TRANSITION BUILDERS
  // ─────────────────────────────────────────

  /// Fade — used for main tab-level screens
  static PageRouteBuilder<T> _fade<T>(
      Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings:                settings,
      transitionDuration:      const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder:             (_, __, ___) => page,
      transitionsBuilder:      (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(
            parent: anim, curve: Curves.easeInOut),
        child: child,
      ),
    );
  }

  /// Slide from right — used for detail / sub screens
  static PageRouteBuilder<T> _slideRight<T>(
      Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings:                settings,
      transitionDuration:      const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder:             (_, __, ___) => page,
      transitionsBuilder:      (_, anim, __, child) {
        final slide = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end:   Offset.zero,
        ).animate(
            CurvedAnimation(parent: anim, curve: Curves.easeOut));
        return SlideTransition(position: slide, child: child);
      },
    );
  }

  /// Slide up from bottom — used for Add Transaction / modals
  static PageRouteBuilder<T> _slideUp<T>(
      Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings:                settings,
      transitionDuration:      const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder:             (_, __, ___) => page,
      transitionsBuilder:      (_, anim, __, child) {
        final slide = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end:   Offset.zero,
        ).animate(
            CurvedAnimation(parent: anim, curve: Curves.easeOut));
        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: anim,
                curve: const Interval(0.0, 0.5,
                    curve: Curves.easeIn)));
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  404 NOT FOUND SCREEN
// ─────────────────────────────────────────────
class _NotFoundScreen extends StatelessWidget {
  final String routeName;
  const _NotFoundScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Color(0xFF5C5C5C), size: 56),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(
                fontSize:   20,
                fontWeight: FontWeight.w600,
                color:      Color(0xFFFFFFFF),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '"$routeName" does not exist',
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF9E9E9E)),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => AppRoutes.pushAndClearStack(
                  context, AppRoutes.home),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color:        const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(14),
                  border:       Border.all(
                      color: const Color(0xFF333333), width: 0.8),
                ),
                child: const Text(
                  'Go Home',
                  style: TextStyle(
                    fontSize:   15,
                    fontWeight: FontWeight.w600,
                    color:      Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}