import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../core/app_theme.dart';
import '../providers/app_provider.dart';
import '../providers/panchang_provider.dart';
import '../providers/vidhi_provider.dart';
import '../providers/audio_provider.dart';
import '../providers/ishta_devta_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/vrat_provider.dart';
import '../services/localization_service.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/auth_modal.dart';
import 'panchang_screen.dart';
import 'vidhi_list_screen.dart';
import 'vidhi_detail_screen.dart';
import 'aarti_list_screen.dart';
import 'aarti_reader_screen.dart';
import 'japa_mala_screen.dart';
import 'bhakt_prime_screen.dart';
import 'settings_screen.dart';
import 'vrat_calendar_screen.dart';
import 'virtual_diya_screen.dart';
import 'wallpaper_gallery_screen.dart';
import 'gita_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);
    final panchangProv = Provider.of<PanchangProvider>(context);
    final vidhiProv = Provider.of<VidhiProvider>(context);
    final audioProv = Provider.of<AudioProvider>(context);
    final ishtaProv = Provider.of<IshtaDevtaProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);
    final vratProv = Provider.of<VratProvider>(context);
    final loc = Provider.of<LocalizationService>(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todayPanchang = panchangProv.panchangData;
    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    final selectedDeity = ishtaProv.selectedDeity;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wb_sunny_rounded, color: AppTheme.divineGold, size: 22),
            const SizedBox(width: 8),
            Text(
              loc.tr('app_name'),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        actions: [
          // Language Switcher Pill
          InkWell(
            onTap: () => _showLanguageModal(context, loc),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.sacredMaroon.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 14, color: AppTheme.marigold),
                  const SizedBox(width: 4),
                  Text(
                    loc.currentLanguage.nativeName,
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.marigold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),

          // User Profile / Login Button
          IconButton(
            icon: Icon(
              authProv.isAuthenticated ? Icons.account_circle : Icons.person_outline,
              color: authProv.isAuthenticated ? Colors.greenAccent : AppTheme.divineGold,
            ),
            tooltip: authProv.isAuthenticated ? authProv.displayName : "Sign In / Profile",
            onPressed: () {
              if (authProv.isAuthenticated) {
                _showProfileDialog(context, authProv);
              } else {
                AuthModal.show(context);
              }
            },
          ),

          // Bhakt Prime Pill
          if (!appProv.isProUser)
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BhaktPrimeScreen()));
              },
              icon: const Icon(Icons.workspace_premium, color: AppTheme.divineGold, size: 18),
              label: Text(
                loc.tr('prime_pass'),
                style: GoogleFonts.poppins(color: AppTheme.divineGold, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),

          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppTheme.divineGold),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Ishta Devta Personalization Banner
            _buildIshtaDevtaBanner(context, selectedDeity, ishtaProv, isDark),

            const SizedBox(height: 18),

            // 2. 8 Divine Navigation Portals (Grid)
            Text(
              "Spiritual Portals • नित्य सेवा",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPortalsGrid(context, loc, isDark),

            const SizedBox(height: 20),

            // 3. Today's Auspicious Muhurat Snippet
            _buildTodayMuhuratCard(context, todayPanchang, formattedDate, isDark),

            const SizedBox(height: 18),

            // 4. Upcoming Vrat & Parana Alert
            if (vratProv.vrats.isNotEmpty)
              _buildUpcomingVratCard(context, vratProv.vrats.first, isDark),

            const SizedBox(height: 18),

            // 5. Bhagavad Gita Shloka / Daily Suvichar
            _buildDailyGitaCard(context, appProv, isDark),

            const SizedBox(height: 20),

            // 6. Featured Sacred Aartis Carousel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Aartis & Chalisas",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AartiListScreen()),
                    );
                  },
                  child: Text("View All", style: GoogleFonts.poppins(color: AppTheme.marigold, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildAartisHorizontalList(context, audioProv, isDark),

            const SizedBox(height: 24),

            // 7. Regional Puja Vidhis & Checklists
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Vedic Puja Vidhis & Samagri",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VidhiListScreen()));
                  },
                  child: Text("View All", style: GoogleFonts.poppins(color: AppTheme.marigold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildVidhisList(context, vidhiProv, isDark),

            const SizedBox(height: 20),

            // 8. AdMob Bottom Banner
            const AdBannerWidget(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- Hero Ishta Devta Darshan Banner ---
  Widget _buildIshtaDevtaBanner(
    BuildContext context,
    IshtaDeity deity,
    IshtaDevtaProvider ishtaProv,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [deity.primaryColor, deity.primaryColor.withValues(alpha: 0.85), const Color(0xFF7E191B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: deity.primaryColor.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "ISHTA DEVTA DARSHAN",
                  style: GoogleFonts.poppins(
                    color: deity.accentColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _showDeityModal(context, ishtaProv),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      Text("Change", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
                      const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(deity.iconSymbol, style: const TextStyle(fontSize: 38)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deity.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      deity.greeting,
                      style: GoogleFonts.poppins(
                        color: deity.accentColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              deity.mantra,
              style: GoogleFonts.poppins(
                color: const Color(0xFFFEF08A),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 8 Divine Portals Grid ---
  Widget _buildPortalsGrid(BuildContext context, LocalizationService loc, bool isDark) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: [
        _buildPortalItem(
          icon: Icons.calendar_month_outlined,
          color: const Color(0xFFD97706),
          label: loc.tr('panchang'),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PanchangScreen())),
          isDark: isDark,
        ),
        _buildPortalItem(
          icon: Icons.local_fire_department_rounded,
          color: const Color(0xFFE11D48),
          label: loc.tr('virtual_diya'),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VirtualDiyaScreen())),
          isDark: isDark,
        ),
        _buildPortalItem(
          icon: Icons.auto_stories_outlined,
          color: const Color(0xFF7C3AED),
          label: loc.tr('vrats'),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VratCalendarScreen())),
          isDark: isDark,
        ),
        _buildPortalItem(
          icon: Icons.menu_book_rounded,
          color: const Color(0xFF0284C7),
          label: loc.tr('aartis'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AartiListScreen()),
            );
          },
          isDark: isDark,
        ),
        _buildPortalItem(
          icon: Icons.circle_outlined,
          color: const Color(0xFFB45309),
          label: loc.tr('japa_mala'),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const JapaMalaScreen())),
          isDark: isDark,
        ),
        _buildPortalItem(
          icon: Icons.temple_hindu_outlined,
          color: const Color(0xFF059669),
          label: loc.tr('vidhis'),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VidhiListScreen())),
          isDark: isDark,
        ),
        _buildPortalItem(
          icon: Icons.wallpaper_rounded,
          color: const Color(0xFF4338CA),
          label: loc.tr('wallpapers'),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WallpaperGalleryScreen())),
          isDark: isDark,
        ),
        _buildPortalItem(
          icon: Icons.menu_book_rounded,
          color: const Color(0xFFB91C1C),
          label: "श्रीमद्भगवद्गीता",
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const GitaHomeScreen(),
            ),
          ),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildPortalItem({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.templeCardDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // --- Today's Muhurat Card ---
  Widget _buildTodayMuhuratCard(BuildContext context, dynamic panchang, String formattedDate, bool isDark) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_twilight, color: AppTheme.marigold, size: 20),
                    const SizedBox(width: 8),
                    Text("Today's Panchang", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                Text(formattedDate, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
            const Divider(height: 18),
            Row(
              children: [
                Expanded(
                  child: _buildPanchangField("Tithi", "${panchang.tithi} (${panchang.paksha})"),
                ),
                Expanded(
                  child: _buildPanchangField("Nakshatra", panchang.nakshatra),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildPanchangField("Abhijit Muhurat", panchang.abhijitMuhurat, isGreen: true),
                ),
                Expanded(
                  child: _buildPanchangField("Rahu Kaal", panchang.rahuKaal, isRed: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanchangField(String title, String val, {bool isGreen = false, bool isRed = false}) {
    Color? color;
    if (isGreen) color = Colors.green;
    if (isRed) color = Colors.redAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted)),
        const SizedBox(height: 2),
        Text(
          val,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // --- Upcoming Vrat Alert ---
  Widget _buildUpcomingVratCard(BuildContext context, dynamic vrat, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: Row(
        children: [
          const Icon(Icons.alarm_on_rounded, color: Color(0xFFB45309), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upcoming Vrat: ${vrat.name}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF92400E), fontSize: 13),
                ),
                Text(
                  "Parana: ${vrat.paranaTiming}",
                  style: GoogleFonts.poppins(fontSize: 11.5, color: const Color(0xFF78350F)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VratCalendarScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB45309),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: const Size(60, 32),
            ),
            child: const Text("View", style: TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  // --- Daily Gita Shloka Card ---
  Widget _buildDailyGitaCard(BuildContext context, AppProvider appProv, bool isDark) {
    const shloka = "कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥";
    const meaning = "You have a right to perform your prescribed duty, but you are not entitled to the fruits of action.";

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GitaHomeScreen()),
        ),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_stories, color: AppTheme.marigold, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "Bhagavad Gita • Verse of the Day",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, size: 18, color: AppTheme.sacredMaroon),
                    tooltip: "Share to WhatsApp",
                    onPressed: () {
                      final text = """
🙏 Shrimad Bhagavad Gita - Chapter 2, Verse 47 🙏

$shloka

Meaning:
"$meaning"

✨ Shared with devotion by ${appProv.familyName}
📱 Read daily Gita shlokas and Panchang on PujaVidhi!
""";
                      SharePlus.instance.share(
                        ShareParams(
                          text: text,
                          subject: "Bhagavad Gita Shloka",
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                shloka,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.sacredMaroon,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                meaning,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "सभी १८ अध्याय पढ़ें →",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.marigold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Aartis Horizontal List ---
  Widget _buildAartisHorizontalList(BuildContext context, AudioProvider audioProv, bool isDark) {
    if (audioProv.isLoading && audioProv.tracks.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
    }

    final tracks = audioProv.tracks.take(6).toList();

    return SizedBox(
      height: 135,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tracks.length,
        itemBuilder: (context, idx) {
          final t = tracks[idx];
          final displayName = t.hindiTitle.isNotEmpty ? t.hindiTitle : t.title;

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => AartiReaderScreen(track: t)));
            },
            child: Container(
              width: 175,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.templeCardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.sacredMaroon.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          t.deity,
                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.sacredMaroon),
                        ),
                      ),
                      const Icon(Icons.menu_book_rounded, color: AppTheme.sacredMaroon, size: 22),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: GoogleFonts.martel(fontSize: 13, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        t.title != displayName ? t.title : "${t.lyrics.length} छंद",
                        style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Vidhis List ---
  Widget _buildVidhisList(BuildContext context, VidhiProvider vidhiProv, bool isDark) {
    if (vidhiProv.isLoading && vidhiProv.vidhis.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
    }

    final vidhis = vidhiProv.vidhis.take(3).toList();

    return Column(
      children: vidhis.map((v) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: AppTheme.sacredMaroon.withValues(alpha: 0.1),
              child: const Icon(Icons.temple_hindu, color: AppTheme.sacredMaroon, size: 20),
            ),
            title: Text(v.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text("${v.regionalTag} • ${v.estimatedMinutes} mins", style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => VidhiDetailScreen(vidhi: v)));
            },
          ),
        );
      }).toList(),
    );
  }

  // --- Modals ---
  void _showLanguageModal(BuildContext context, LocalizationService loc) {
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
            Text("Choose your preferred regional language", style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted)),
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

  void _showDeityModal(BuildContext context, IshtaDevtaProvider ishtaProv) {
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
            Text("Your home screen & daily devotion will adapt to your chosen deity", style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted)),
            const Divider(height: 20),
            ...IshtaDevtaProvider.availableDeities.map((d) {
              final isSel = ishtaProv.selectedDeity.id == d.id;
              return ListTile(
                leading: Text(d.iconSymbol, style: const TextStyle(fontSize: 26)),
                title: Text(d.name, style: GoogleFonts.poppins(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                subtitle: Text(d.greeting, maxLines: 1),
                trailing: isSel ? const Icon(Icons.check_circle, color: AppTheme.sacredMaroon) : null,
                onTap: () {
                  ishtaProv.selectDeity(d);
                  Navigator.of(ctx).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context, AuthProvider authProv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Devotee Account", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${authProv.displayName}", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            Text("Email: ${authProv.email}", style: GoogleFonts.poppins(color: AppTheme.textMuted)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: const Text("Cloud Synced with Firebase", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              authProv.signOut();
              Navigator.of(ctx).pop();
            },
            child: const Text("Sign Out", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.sacredMaroon),
            child: const Text("Close", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
