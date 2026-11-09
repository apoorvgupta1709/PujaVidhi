import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
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
          content: Text("स्वागत है, ${authProv.displayName}! Welcome back."),
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

  void _showForgotPasswordDialog() {
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
              "Reset Password",
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
                labelText: "Email Address",
                prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.marigold),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.sacredMaroon,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Password recovery email sent. Please check your inbox."),
                ),
              );
            },
            child: const Text("Send Instructions"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "भक्त लॉगिन (Devotee Sign In)",
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
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.divineGold,
                      AppTheme.sacredMaroon,
                      const Color(0xFF3B0709),
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
                "पूजाविधि में आपका स्वागत है",
                style: GoogleFonts.martel(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.divineGold : AppTheme.sacredMaroon,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Sign in to sync your Japa Sadhana, Bhagavad Gita bookmarks, and customized festival cards across devices.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 12.5, color: AppTheme.textMuted, height: 1.4),
              ),

              const SizedBox(height: 28),

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
                  labelText: "ईमेल पता (Email Address)",
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
                  labelText: "पासवर्ड (Password)",
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
                  onPressed: _showForgotPasswordDialog,
                  child: Text(
                    "पासवर्ड भूल गए? (Forgot Password?)",
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
                              "लॉगिन करें (Sign In)",
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Or divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      "अथवा",
                      style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              // Continue as Guest Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.person_outline, size: 18),
                  label: Text(
                    "अतिथि रूप में जारी रखें (Continue as Guest)",
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white70 : AppTheme.sacredMaroon,
                    side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "नया खाता बनाना है? ",
                    style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textMuted),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      "रजिस्टर करें (Sign Up)",
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
