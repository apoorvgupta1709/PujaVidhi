import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _familyCtrl = TextEditingController(text: "Sharma Parivar");
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _familyCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordCtrl.text.trim() != _confirmPasswordCtrl.text.trim()) {
      setState(() => _errorMessage = "Passwords do not match. Please re-enter.");
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final appProv = Provider.of<AppProvider>(context, listen: false);

    final success = await authProv.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      if (_familyCtrl.text.trim().isNotEmpty) {
        await appProv.setFamilyName(_familyCtrl.text.trim());
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("भक्त पंजीकरण सफल! Welcome, ${_nameCtrl.text.trim()}."),
          backgroundColor: Colors.green[800],
        ),
      );
      Navigator.of(context).pop();
    } else {
      setState(() {
        _errorMessage = authProv.errorMessage ?? "Registration failed. Please check your details.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "नया भक्त पंजीकरण (Create Account)",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
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
              // Sacred Header Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.sacredMaroon,
                      AppTheme.sacredMaroon.withValues(alpha: 0.85),
                      const Color(0xFF4A0E10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.sacredMaroon.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Text("🪔", style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "सनातनी भक्त परिवार",
                            style: GoogleFonts.martel(
                              color: AppTheme.divineGold,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Create your account to sync bookmarks, daily japa records, and personalized cards.",
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
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

              // Full Name
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "भक्त का नाम (Devotee Full Name)",
                  hintText: "e.g. Ramesh Kumar Sharma",
                  prefixIcon: const Icon(Icons.person_outline, color: AppTheme.marigold),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: isDark ? AppTheme.templeCardDark : Colors.grey[50],
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return "Please enter your name";
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Family Name (for greeting cards)
              TextFormField(
                controller: _familyCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "परिवार का नाम (Family Name for Greeting Cards)",
                  hintText: "e.g. Sharma Parivar, Gupta Parivar",
                  prefixIcon: const Icon(Icons.family_restroom, color: AppTheme.marigold),
                  helperText: "Appears on your 4K festival cards and daily suvichar shares",
                  helperStyle: GoogleFonts.poppins(fontSize: 10.5, color: AppTheme.textMuted),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: isDark ? AppTheme.templeCardDark : Colors.grey[50],
                ),
              ),

              const SizedBox(height: 14),

              // Email
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

              const SizedBox(height: 14),

              // Password
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "पासवर्ड (Password)",
                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.marigold),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: isDark ? AppTheme.templeCardDark : Colors.grey[50],
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return "Please choose a password";
                  if (val.length < 6) return "Password must be at least 6 characters";
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordCtrl,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: "पासवर्ड की पुष्टि (Confirm Password)",
                  prefixIcon: const Icon(Icons.lock_reset, color: AppTheme.marigold),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  filled: true,
                  fillColor: isDark ? AppTheme.templeCardDark : Colors.grey[50],
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return "Please confirm your password";
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleRegister,
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
                            const Icon(Icons.person_add_rounded, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "खाता बनाएं (Register Account)",
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "पहले से खाता है? ",
                    style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textMuted),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      "यहाँ लॉगिन करें (Sign In)",
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
