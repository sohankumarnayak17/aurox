import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../core/theme.dart';
import '../../providers/auth_providers.dart';
import '../../routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure      = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
        _nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      AppRoutes.pushAndClearStack(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Registration failed'),
            backgroundColor: AppColors.expense),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => AppRoutes.pop(context),
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSubtle, width: 0.8),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary, size: 20),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Create account', style: AppTextStyles.headingLarge),
                const SizedBox(height: 6),
                Text('Start tracking your finances', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 36),
                _field('Full Name', _nameCtrl, 'Your name', Icons.person_outline,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null),
                const SizedBox(height: 16),
                _field('Email', _emailCtrl, 'you@example.com', Icons.email_outlined,
                    type: TextInputType.emailAddress,
                    validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null),
                const SizedBox(height: 16),
                _field('Password', _passCtrl, 'Min 6 characters', Icons.lock_outline,
                    obscure: true,
                    validator: (v) => (v == null || v.length < 6) ? 'At least 6 characters' : null),
                const SizedBox(height: 16),
                _field('Confirm Password', _confirmCtrl, 'Repeat password', Icons.lock_outline,
                    obscure: true,
                    validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: loading ? null : _submit,
                    child: loading
                        ? const SizedBox(width: 22, height: 22,
                            child: CircularProgressIndicator(color: AppColors.textOnCard, strokeWidth: 2))
                        : const Text('Create Account'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: AppTextStyles.bodyMedium),
                    GestureDetector(
                      onTap: () => AppRoutes.pop(context),
                      child: Text('Sign In',
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.income, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint, IconData icon,
      {TextInputType type = TextInputType.text, bool obscure = false, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          obscureText: obscure,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
