import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_constants.dart';
import '../core/sound_service.dart';
import '../providers/app_provider.dart';
import 'bhakt_prime_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);

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

          // Sacred Audio Tools
          Text(
            "Sacred Audio & Chimes",
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications_active_outlined, color: AppTheme.marigold),
                  title: Text("Test Brass Temple Bell", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: Text("Touch to hear the sacred bell chime", style: GoogleFonts.poppins(fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_circle_outline, color: AppTheme.marigold),
                    onPressed: () => SoundService.playTempleBell(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.volume_up_outlined, color: AppTheme.sacredMaroon),
                  title: Text("Test Divine Shankh", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: Text("Touch to hear the conch vibration", style: GoogleFonts.poppins(fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_circle_outline, color: AppTheme.sacredMaroon),
                    onPressed: () => SoundService.playShankh(),
                  ),
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
