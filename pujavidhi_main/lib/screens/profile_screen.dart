import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import '../providers/japa_provider.dart';
import '../providers/gita_provider.dart';
import '../providers/ishta_devta_provider.dart';
import 'bhakt_prime_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditFamilyNameDialog(BuildContext context, AppProvider appProv) {
    final ctrl = TextEditingController(text: appProv.familyName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.family_restroom, color: AppTheme.divineGold),
            const SizedBox(width: 8),
            Text(
              "परिवार का नाम बदलें",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "यह नाम आपके 4K ग्रीटिंग कार्ड्स और दैनिक सुविचार में प्रदर्शित होगा:",
              style: GoogleFonts.poppins(fontSize: 12.5, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: ctrl,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: "Family Name",
                hintText: "e.g. Sharma Parivar, Gupta Family",
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
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                await appProv.setFamilyName(ctrl.text.trim());
              }
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showChangeDeityDialog(BuildContext context, IshtaDevtaProvider ishtaProv) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "अपने इष्ट देव का चयन करें (Choose Ishta Devta)",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "आपके मुख्य पृष्ठ और प्रार्थनाओं को इनके अनुरूप संरेखित किया जाएगा।",
                style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: IshtaDevtaProvider.availableDeities.map((deity) {
                  final isSelected = ishtaProv.selectedDeity.id == deity.id;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(deity.iconSymbol, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text(
                          deity.name,
                          style: GoogleFonts.poppins(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: AppTheme.divineGold,
                    onSelected: (val) {
                      if (val) {
                        ishtaProv.selectDeity(deity);
                        Navigator.of(ctx).pop();
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showSignOutConfirm(BuildContext context, AuthProvider authProv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "लॉग आउट करें? (Sign Out)",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "क्या आप वाकई अपने खाते से लॉग आउट करना चाहते हैं? आप पुनः कभी भी लॉगिन कर सकते हैं।",
          style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[800],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await authProv.signOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("लॉग आउट सफल। You are now in Guest Mode.")),
                );
              }
            },
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final appProv = Provider.of<AppProvider>(context);
    final japaProv = Provider.of<JapaProvider>(context);
    final gitaProv = Provider.of<GitaProvider>(context);
    final ishtaProv = Provider.of<IshtaDevtaProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isAuthenticated = authProv.isAuthenticated;
    final user = authProv.user;
    final totalMalas = japaProv.history.fold<int>(0, (sum, r) => sum + r.totalRounds);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "भक्त प्रोफ़ाइल (Devotee Profile)",
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // 1. Devotee Hero Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.sacredMaroon,
                    AppTheme.sacredMaroon.withValues(alpha: 0.88),
                    const Color(0xFF4A0E10),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.6), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.sacredMaroon.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.divineGold,
                              AppTheme.sacredMaroon,
                            ],
                          ),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38, blurRadius: 8),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isAuthenticated
                                ? (user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : "भ")
                                : "🕉️",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Name & Email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    authProv.displayName,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                if (appProv.isProUser)
                                  const Icon(Icons.verified, color: AppTheme.divineGold, size: 18),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isAuthenticated ? user.email : "Guest Devotee (Offline Mode)",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            // Devotee Status Pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: isAuthenticated
                                    ? Colors.green[800]!.withValues(alpha: 0.4)
                                    : Colors.orange[900]!.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isAuthenticated ? Colors.greenAccent : Colors.orangeAccent,
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                isAuthenticated ? "सत्यापित भक्त (Verified)" : "अतिथि भक्त (Guest)",
                                style: GoogleFonts.poppins(
                                  color: isAuthenticated ? Colors.greenAccent : Colors.orangeAccent,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // If Guest: Quick Login Prompt Card
                  if (!isAuthenticated) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.cloud_sync, color: AppTheme.divineGold, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Login to sync Japa history & Gita bookmarks across devices.",
                              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.divineGold,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            },
                            child: const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Bhakt Prime Membership Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: AppTheme.divineGold.withValues(alpha: appProv.isProUser ? 0.8 : 0.3),
                  width: appProv.isProUser ? 1.5 : 1,
                ),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appProv.isProUser
                            ? AppTheme.divineGold.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.15),
                      ),
                      child: Icon(
                        Icons.workspace_premium,
                        color: appProv.isProUser ? AppTheme.divineGold : Colors.grey,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "भक्त प्राइम पास (Bhakt Prime)",
                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              if (appProv.isProUser) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.divineGold,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    "ACTIVE",
                                    style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appProv.isProUser
                                ? "Ad-free Vedic darshan & watermark-free 4K studio."
                                : "100% Ad-Free, offline downloads & 4K HD Wallpapers.",
                            style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    if (!appProv.isProUser)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.sacredMaroon,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const BhaktPrimeScreen()),
                          );
                        },
                        child: const Text("Upgrade", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. Devotional Sadhana Metrics Grid
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "आपकी साधना एवं संग्रह (Sadhana & Bookmarks)",
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                // Metric 1: Japa Malas
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.templeCardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.25)),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("📿", style: TextStyle(fontSize: 22)),
                            Icon(Icons.trending_up, size: 16, color: Colors.greenAccent),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$totalMalas",
                          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "माला जप पूर्ण (Japa Malas)",
                          style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Metric 2: Gita Bookmarks
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.templeCardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.25)),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("📖", style: TextStyle(fontSize: 22)),
                            Icon(Icons.bookmark, size: 16, color: AppTheme.divineGold),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${gitaProv.bookmarkedIds.length}",
                          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "गीता श्लोक सहेजे (Gita Verses)",
                          style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 4. Personalization & Settings Tiles
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "व्यक्तिगत धार्मिक प्राथमिकताएं (Preferences)",
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  // Ishta Devta Tile
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.divineGold.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          ishtaProv.selectedDeity.iconSymbol,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    title: Text(
                      "इष्ट देव (Ishta Devta)",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13.5),
                    ),
                    subtitle: Text(
                      ishtaProv.selectedDeity.name,
                      style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.marigold),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.divineGold),
                    onTap: () => _showChangeDeityDialog(context, ishtaProv),
                  ),

                  const Divider(height: 1),

                  // Family Name for Greeting Cards Tile
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.sacredMaroon.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.family_restroom, color: AppTheme.marigold, size: 20),
                    ),
                    title: Text(
                      "ग्रीटिंग कार्ड परिवार का नाम (Family Name)",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13.5),
                    ),
                    subtitle: Text(
                      appProv.familyName,
                      style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.marigold),
                    ),
                    trailing: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.divineGold),
                    onTap: () => _showEditFamilyNameDialog(context, appProv),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. Account Actions (Sign In / Sign Out / Register)
            if (isAuthenticated)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => _showSignOutConfirm(context, authProv),
                  icon: const Icon(Icons.logout, size: 18, color: Colors.redAccent),
                  label: Text(
                    "खाते से लॉग आउट करें (Sign Out)",
                    style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              )
            else ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: Text(
                    "भक्त लॉगिन करें (Sign In)",
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sacredMaroon,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
                  },
                  icon: const Icon(Icons.person_add_rounded, size: 18),
                  label: Text(
                    "नया खाता बनाएं (Create Account)",
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white70 : AppTheme.sacredMaroon,
                    side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
