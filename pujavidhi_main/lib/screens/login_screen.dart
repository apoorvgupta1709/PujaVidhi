import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/localization_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProv.signIn(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Welcome back, ${authProv.displayName}!"),
          backgroundColor: Colors.green[800],
        ),
      );
      Navigator.of(context).pop();
    } else {
      setState(() {
        _errorMessage = authProv.errorMessage ?? "Invalid credentials. Please verify email and password.";
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProv.signInWithGoogle();

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Welcome, ${authProv.displayName}! Google Sign-In successful."),
          backgroundColor: Colors.green[800],
        ),
      );
      Navigator.of(context).pop();
    } else {
      setState(() {
        _errorMessage = authProv.errorMessage ?? "Google Sign-In failed.";
      });
    }
  }

  void _showForgotPasswordDialog(LocalizationService loc) {
    final resetEmailCtrl = TextEditingController(text: _emailCtrl.text.trim());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.lock_reset, color: AppTheme.divineGold),
            const SizedBox(width: 8),
            Text(
              loc.tr('forgot_password'),
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your registered email address. Password reset instructions will be sent to your inbox.",
              style: GoogleFonts.poppins(fontSize: 12.5, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: resetEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: loc.tr('email'),
                hintText: "devotee@example.com",
                prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.marigold),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(loc.tr('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.sacredMaroon,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (resetEmailCtrl.text.trim().isNotEmpty) {
                final authProv = Provider.of<AuthProvider>(context, listen: false);
                await authProv.sendPasswordReset(resetEmailCtrl.text.trim());
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                }
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password reset email sent! Please check your inbox."),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text("Send Reset Link"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = Provider.of<LocalizationService>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.tr('login_title'),
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Sacred Vedic Emblem Header
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      AppTheme.divineGold,
                      AppTheme.sacredMaroon,
                      Color(0xFF3B0709),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.sacredMaroon.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: AppTheme.divineGold, width: 2),
                ),
                child: const Center(
                  child: Text("🕉️", style: TextStyle(fontSize: 44)),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                loc.tr('welcome_title'),
                textAlign: TextAlign.center,
                style: GoogleFonts.martel(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.divineGold : AppTheme.sacredMaroon,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                loc.tr('login_subtitle'),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 12.5, color: AppTheme.textMuted, height: 1.4),
              ),

              const SizedBox(height: 24),

              // 1. One-Tap Google Sign-In Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _isSubmitting ? null : _handleGoogleSignIn,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                    side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
                        width: 20,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.blue, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        loc.tr('continue_google'),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Or Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      loc.languageCode == 'en' ? "OR WITH EMAIL" : "अथवा ईमेल से",
                      style: GoogleFonts.poppins(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 18),

              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[900]!.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              // Email Field
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: loc.tr('email'),
                  hintText: "devotee@example.com",
                  prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.marigold),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: isDark ? AppTheme.templeCardDark : Colors.grey[50],
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return "Please enter your email";
                  if (!val.contains('@') || !val.contains('.')) return "Enter a valid email address";
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: loc.tr('password'),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.marigold),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: isDark ? AppTheme.templeCardDark : Colors.grey[50],
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return "Please enter your password";
                  if (val.length < 6) return "Password must be at least 6 characters";
                  return null;
                },
              ),

              const SizedBox(height: 8),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showForgotPasswordDialog(loc),
                  child: Text(
                    loc.tr('forgot_password'),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.divineGold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sacredMaroon,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: AppTheme.divineGold, strokeWidth: 2.5),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.login_rounded, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              loc.tr('sign_in'),
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 18),

              // Continue as Guest Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.person_outline, size: 18),
                  label: Text(
                    loc.tr('continue_guest'),
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white70 : AppTheme.sacredMaroon,
                    side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    loc.languageCode == 'en' ? "Don't have an account? " : "खाता नहीं है? ",
                    style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textMuted),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      loc.languageCode == 'en' ? "Sign Up" : "पंजीकरण करें",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.divineGold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
