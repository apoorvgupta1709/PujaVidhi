import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_constants.dart';
import '../providers/app_provider.dart';
import '../providers/ishta_devta_provider.dart';
import '../providers/auth_provider.dart';
import '../services/localization_service.dart';
import 'bhakt_prime_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);
    final loc = Provider.of<LocalizationService>(context);
    final ishta = Provider.of<IshtaDevtaProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings & About"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Bhakt Prime Card
          Card(
            color: appProv.isProUser
                ? Colors.green.withValues(alpha: 0.12)
                : AppTheme.sacredMaroon.withValues(alpha: 0.08),
            child: ListTile(
              leading: Icon(
                appProv.isProUser ? Icons.verified_user_rounded : Icons.workspace_premium_rounded,
                color: appProv.isProUser ? Colors.green : AppTheme.marigold,
                size: 32,
              ),
              title: Text(
                appProv.isProUser ? "Bhakt Prime Active" : "Upgrade to Bhakt Prime",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Text(
                appProv.isProUser
                    ? "Lifetime Ad-Free Access & Unlimited Downloads"
                    : "Remove ads, unlock offline audio & cards for ₹${appProv.activePassPrice}",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              trailing: appProv.isProUser
                  ? null
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const BhaktPrimeScreen()),
                        );
                      },
                      child: const Text("View"),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Preferences Section
          Text(
            "Preferences",
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined, color: AppTheme.sacredMaroon),
                  title: Text("Devotee Cloud Account", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    auth.isAuthenticated ? "${auth.displayName} (${auth.email})" : "Guest Mode (Tap to Sign In)",
                    style: GoogleFonts.poppins(fontSize: 12, color: auth.isAuthenticated ? Colors.green : AppTheme.marigold),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.favorite_border, color: AppTheme.sacredMaroon),
                  title: Text("Ishta Devta", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: Text("${ishta.selectedDeity.name} (${ishta.selectedDeity.greeting})", style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.marigold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => _showDeityPicker(context, ishta),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language, color: AppTheme.sacredMaroon),
                  title: Text("App Language", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: Text("${loc.currentLanguage.nativeName} (${loc.currentLanguage.englishName})", style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.marigold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => _showLanguagePicker(context, loc),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined, color: AppTheme.sacredMaroon),
                  title: Text("Dark Temple Mode", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  value: appProv.isDarkMode,
                  activeThumbColor: AppTheme.divineGold,
                  onChanged: (_) => appProv.toggleDarkMode(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.family_restroom, color: AppTheme.sacredMaroon),
                  title: Text("Default Family Name", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: Text(appProv.familyName, style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.marigold)),
                  trailing: const Icon(Icons.edit_outlined, size: 18),
                  onTap: () => _editFamilyNameDialog(context, appProv),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Legal & About
          Text(
            "Legal & Support",
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.policy_outlined, color: AppTheme.sacredMaroon),
                  title: Text("Privacy Policy", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => _showPrivacyPolicy(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore_outlined, color: AppTheme.sacredMaroon),
                  title: Text("Restore Bhakt Prime Pass", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () async {
                    await appProv.activateBhaktPrimePass();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✨ Bhakt Prime Pass active!"), backgroundColor: Colors.green),
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // Mandatory Universal Signature Attribution - STRICTLY IN SETTINGS
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.divineGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    AppConstants.settingsAttribution,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.sacredMaroon,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "PujaVidhi Sanatan Vedic Suite",
                  style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showDeityPicker(BuildContext context, IshtaDevtaProvider ishta) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose Your Ishta Devta", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 20),
            ...IshtaDevtaProvider.availableDeities.map((d) {
              final isSel = ishta.selectedDeity.id == d.id;
              return ListTile(
                leading: Text(d.iconSymbol, style: const TextStyle(fontSize: 26)),
                title: Text(d.name, style: GoogleFonts.poppins(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                subtitle: Text(d.greeting),
                trailing: isSel ? const Icon(Icons.check_circle, color: AppTheme.sacredMaroon) : null,
                onTap: () {
                  ishta.selectDeity(d);
                  Navigator.of(ctx).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, LocalizationService loc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select App Language", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 20),
            ...AppLanguage.values.map((l) {
              final isSel = loc.currentLanguage == l;
              return ListTile(
                title: Text(l.nativeName, style: GoogleFonts.poppins(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                subtitle: Text(l.englishName),
                trailing: isSel ? const Icon(Icons.check_circle, color: AppTheme.sacredMaroon) : null,
                onTap: () {
                  loc.setLanguage(l);
                  Navigator.of(ctx).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _editFamilyNameDialog(BuildContext context, AppProvider appProv) {
    final controller = TextEditingController(text: appProv.familyName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Family Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "e.g. Sharma Family",
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              appProv.setFamilyName(controller.text);
              Navigator.of(ctx).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Privacy Policy"),
        content: const SingleChildScrollView(
          child: Text(
            "PujaVidhi respects your privacy. All your prayer rituals, Japa counter logs, and customized greeting names are kept private and secure. Offline audio downloads are stored safely on your device.\n\nFor support contact: apoorvgupta1709@gmail.com\n\nMade with ❤️ by Apoorv",
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Close")),
        ],
      ),
    );
  }
}
