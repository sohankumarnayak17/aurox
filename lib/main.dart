import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light, systemNavigationBarColor: Color(0xFF0D0D0D), systemNavigationBarIconBrightness: Brightness.light));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const AuroxApp());
}

class AuroxApp extends StatelessWidget {
  const AuroxApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurox Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: const Color(0xFF0D0D0D), useMaterial3: true, colorScheme: const ColorScheme.dark(primary: Colors.white, surface: Color(0xFF161616), onSurface: Colors.white)),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
