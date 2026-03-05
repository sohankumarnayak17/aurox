import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  STEP 1 TEST — No Firebase, No Provider
//  Use this to confirm Flutter is running.
//  Once you see the dark wallet screen,
//  swap back to the full main.dart
// ─────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:          Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                     'Aurox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness:              Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        useMaterial3:            true,
      ),
      home: const TestHomeScreen(),
    );
  }
}

class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo
              Container(
                width:  72,
                height: 72,
                decoration: BoxDecoration(
                  color:        const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF333333), width: 1),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Aurox',
                style: TextStyle(
                  fontSize:      32,
                  fontWeight:    FontWeight.w700,
                  color:         Colors.white,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Flutter is working ✓',
                style: TextStyle(
                    fontSize: 16, color: Color(0xFF4DFF9B)),
              ),
              const SizedBox(height: 48),

              // Balance card
              Container(
                width:   double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color:        const Color(0xFF161616),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF333333), width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                          fontSize: 11,
                          color:    Color(0xFF5C5C5C),
                          letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$5,420.00',
                      style: TextStyle(
                        fontSize:      32,
                        fontWeight:    FontWeight.w700,
                        color:         Colors.white,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(height: 0.8, color: const Color(0xFF2A2A2A)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _stat('Income',  '\$3,200.00', const Color(0xFF4DFF9B), Icons.arrow_downward_rounded)),
                        Container(width: 0.8, height: 40, color: const Color(0xFF2A2A2A)),
                        Expanded(child: _stat('Expense', '\$1,780.00', const Color(0xFFFF4D4D), Icons.arrow_upward_rounded)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Transaction items
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize:   17,
                  fontWeight: FontWeight.w600,
                  color:      Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _txTile('Spotify',  'Entertainment', '-\$15.00',  Icons.headphones_outlined,      const Color(0xFFFF4D4D)),
              const SizedBox(height: 8),
              _txTile('Grocery',  'Food',           '-\$150.00', Icons.shopping_basket_outlined, const Color(0xFFFF4D4D)),
              const SizedBox(height: 8),
              _txTile('Salary',   'Income',         '+\$3,200.00', Icons.account_balance_wallet_outlined, const Color(0xFF4DFF9B)),
            ],
          ),
        ),
      ),

      // Bottom nav
      bottomNavigationBar: Container(
        height:  72,
        decoration: const BoxDecoration(
          color: Color(0xFF161616),
          border: Border(
              top: BorderSide(color: Color(0xFF2A2A2A), width: 0.8)),
        ),
        child: Row(
          children: [
            _navItem(Icons.home_rounded,       'Home',      true),
            _navItem(Icons.bar_chart_rounded,  'Analytics', false),
            _navItem(Icons.add_circle_rounded, 'Add',       false),
            _navItem(Icons.person_rounded,     'Profile',   false),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Color color, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color:        color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 15),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF5C5C5C),
                    letterSpacing: 0.8)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _txTile(String title, String cat, String amount,
      IconData icon, Color amtColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color:        const Color(0xFF161616),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF333333), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color:        const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: const Color(0xFF9E9E9E), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize:   14,
                        fontWeight: FontWeight.w600,
                        color:      Colors.white)),
                const SizedBox(height: 3),
                Text(cat,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF5C5C5C))),
              ],
            ),
          ),
          Text(amount,
              style: TextStyle(
                  fontSize:   14,
                  fontWeight: FontWeight.w600,
                  color:      amtColor)),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: active ? Colors.white : const Color(0xFF5C5C5C),
              size: 22),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize:   10,
                  color: active
                      ? Colors.white
                      : const Color(0xFF5C5C5C))),
        ],
      ),
    );
  }
}