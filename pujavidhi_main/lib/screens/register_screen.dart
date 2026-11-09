import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import '../services/localization_service.dart';
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
          content: Text("Welcome, ${_nameCtrl.text.trim()}! Devotee registration successful."),
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

  Future<void> _handleGoogleSignUp() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final appProv = Provider.of<AppProvider>(context, listen: false);

    final success = await authProv.signInWithGoogle();

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      if (_familyCtrl.text.trim().isNotEmpty) {
        await appProv.setFamilyName(_familyCtrl.text.trim());
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Welcome, ${authProv.displayName}! Registered with Google successfully."),
          backgroundColor: Colors.green[800],
        ),
      );
      Navigator.of(context).pop();
    } else {
      setState(() {
        _errorMessage = authProv.errorMessage ?? "Google registration failed.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = Provider.of<LocalizationService>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.tr('register_title'),
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
                            loc.languageCode == 'en' ? "Sanatan Devotee Suite" : "सनातनी भक्त परिवार",
                            style: GoogleFonts.martel(
                              color: AppTheme.divineGold,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            loc.languageCode == 'en'
                                ? "Create your cloud account to sync bookmarks, daily japa records, and personalized cards."
                                : "अपनी जप साधना, बुकमार्क और व्यक्तिगत शुभकामना कार्ड्स सिंक करने हेतु खाता बनाएं।",
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 1. One-Tap Google Sign-Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _isSubmitting ? null : _handleGoogleSignUp,
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
                        loc.languageCode == 'en' ? "Sign Up with Google" : "Google के साथ पंजीकरण करें",
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
                      loc.languageCode == 'en' ? "OR FILL DETAILS" : "अथवा विवरण भरें",
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
                  labelText: loc.tr('full_name'),
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
                  labelText: loc.tr('family_name'),
                  hintText: "e.g. Sharma Parivar, Gupta Parivar",
                  prefixIcon: const Icon(Icons.family_restroom, color: AppTheme.marigold),
                  helperText: loc.languageCode == 'en'
                      ? "Appears on your 4K festival cards and daily suvichar shares"
                      : "यह आपके 4K त्योहार कार्ड और सुविचार पर सप्रेम भेंट के रूप में दिखेगा",
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

              const SizedBox(height: 14),

              // Password
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: loc.tr('password'),
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
                  labelText: loc.tr('confirm_password'),
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
                              loc.tr('create_account'),
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
                    loc.languageCode == 'en' ? "Already have an account? " : "पहले से खाता है? ",
                    style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textMuted),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      loc.languageCode == 'en' ? "Sign In" : "यहाँ लॉगिन करें",
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
