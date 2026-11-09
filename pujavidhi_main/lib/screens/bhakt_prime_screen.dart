import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_modal.dart';

class BhaktPrimeScreen extends StatefulWidget {
  const BhaktPrimeScreen({super.key});

  @override
  State<BhaktPrimeScreen> createState() => _BhaktPrimeScreenState();
}

class _BhaktPrimeScreenState extends State<BhaktPrimeScreen> {
  bool _isProcessing = false;

  void _handleCheckout(AppProvider appProv, AuthProvider authProv) async {
    // Require Login/Registration before buying subscription
    if (authProv.isGuest) {
      final loggedIn = await AuthModal.show(
        context,
        title: "Sign In Required for Bhakt Prime",
        subtitle: "Please create a free account or sign in to secure your lifetime pass across devices.",
      );
      if (!loggedIn) return;
    }

    setState(() => _isProcessing = true);
    // Simulate Razorpay gateway flow / integration
    await Future.delayed(const Duration(milliseconds: 900));

    await appProv.activateBhaktPrimePass();
    await authProv.markPro(true);

    if (mounted) {
      setState(() => _isProcessing = false);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.verified_rounded, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              Text("Bhakt Prime Active!", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Text(
            "Hari Om! You now have lifetime Ad-Free access, unlimited audio downloads, and watermark-free festival cards linked to your cloud account.",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text("Enter Sacred Space"),
            ),
          ],
        ),
      );
    }
  }

  void _restorePurchases(AppProvider appProv) async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 700));
    await appProv.activateBhaktPrimePass();

    if (mounted) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✨ Bhakt Prime Pass restored successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bhakt Prime Pass"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Prime Hero Badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.sacredMaroon, Color(0xFF4A0A0E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.divineGold, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.sacredMaroon.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.divineGold.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.workspace_premium_rounded, color: AppTheme.divineGold, size: 54),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Bhakt Prime Pass",
                    style: GoogleFonts.poppins(
                      color: AppTheme.divineGold,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    "Lifetime Divine Access • Ad-Free Forever",
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 18),

                  // Pricing Pill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "₹149",
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 20,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "₹${appProv.activePassPrice}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "33% OFF",
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "One-time payment • Lifetime validity • No recurring fees",
                    style: GoogleFonts.poppins(color: AppTheme.divineGold, fontSize: 11),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Benefits Checklist
            _buildBenefitTile("100% Ad-Free Experience", "Zero banners, interstitials, or video ads across all screens."),
            _buildBenefitTile("Unlimited Offline Audio", "Download high-definition aartis & chalisas to your device forever."),
            _buildBenefitTile("Watermark-Free Cards", "Create and share pristine festive greetings on WhatsApp without watermarks."),
            _buildBenefitTile("Cloud Sadhana Backup", "Safeguard your 108 Japa Mala chanting streaks and milestone history."),

            const SizedBox(height: 30),

            // CTA Button
            if (appProv.isProUser)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green),
                ),
                child: Center(
                  child: Text(
                    "✅ Bhakt Prime Pass is Active on this Device",
                    style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : () => _handleCheckout(appProv, authProv),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sacredMaroon,
                    foregroundColor: AppTheme.divineGold,
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: AppTheme.divineGold)
                      : Text(
                          "GET BHAKT PRIME PASS (₹${appProv.activePassPrice})",
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

            const SizedBox(height: 14),

            // Restore Purchase Button (Checklist item 6)
            TextButton(
              onPressed: _isProcessing ? null : () => _restorePurchases(appProv),
              child: Text(
                "Restore Previous Purchase",
                style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitTile(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.divineGold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
