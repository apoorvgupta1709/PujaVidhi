import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/app_theme.dart';
import '../providers/app_provider.dart';
import '../providers/panchang_provider.dart';
import '../providers/vidhi_provider.dart';
import '../providers/audio_provider.dart';
import 'panchang_screen.dart';
import 'vidhi_list_screen.dart';
import 'vidhi_detail_screen.dart';
import 'audio_player_screen.dart';
import 'japa_mala_screen.dart';
import 'card_maker_screen.dart';
import 'bhakt_prime_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);
    final panchangProv = Provider.of<PanchangProvider>(context);
    final vidhiProv = Provider.of<VidhiProvider>(context);
    final audioProv = Provider.of<AudioProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final todayPanchang = panchangProv.panchangData;
    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wb_sunny_rounded, color: AppTheme.divineGold, size: 22),
            const SizedBox(width: 8),
            Text(
              "PujaVidhi",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        actions: [
          if (!appProv.isProUser)
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BhaktPrimeScreen()));
              },
              icon: const Icon(Icons.workspace_premium, color: AppTheme.divineGold, size: 18),
              label: Text(
                "PRIME",
                style: GoogleFonts.poppins(color: AppTheme.divineGold, fontWeight: FontWeight.bold, fontSize: 12),
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
            // Daily Auspicious Ticker Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF4A1012), const Color(0xFF240608)]
                      : [AppTheme.sacredMaroon, const Color(0xFF9E2A2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.sacredMaroon.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: GoogleFonts.poppins(color: AppTheme.divineGold, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.divineGold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.6)),
                        ),
                        child: Text(
                          todayPanchang.paksha,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    todayPanchang.specialFestival,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tithi: ${todayPanchang.tithi} • Nakshatra: ${todayPanchang.nakshatra}",
                    style: GoogleFonts.poppins(color: AppTheme.warmCream.withValues(alpha: 0.9), fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PanchangScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.divineGold,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wb_sunny_outlined, size: 16, color: AppTheme.deepTempleNight),
                          const SizedBox(width: 6),
                          Text(
                            "Abhijit: ${todayPanchang.abhijitMuhurat}",
                            style: GoogleFonts.poppins(
                              color: AppTheme.deepTempleNight,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.deepTempleNight),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Daily Suvichar Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.templeCardDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.divineGold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.format_quote_rounded, color: AppTheme.marigold, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "आज का सुविचार (Daily Wisdom)",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.marigold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "\"कर्मण्येवाधिकारस्ते मा फलेषु कदाचन। मन की शुद्धि ही सच्ची पूजा है।\"",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: isDark ? AppTheme.textLight : AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Quick Feature Grid
            Text(
              "Sacred Sadhana & Rituals",
              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                _buildActionCard(
                  context,
                  title: "Daily Panchang",
                  subtitle: "Muhurat & Choghadiya",
                  icon: Icons.calendar_month_outlined,
                  color: const Color(0xFFD32F2F),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PanchangScreen())),
                ),
                _buildActionCard(
                  context,
                  title: "108 Japa Mala",
                  subtitle: "Haptic Bead Counter",
                  icon: Icons.donut_large_rounded,
                  color: const Color(0xFFE65100),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const JapaMalaScreen())),
                ),
                _buildActionCard(
                  context,
                  title: "Vedic Puja Vidhi",
                  subtitle: "Rituals & Samagri",
                  icon: Icons.auto_stories_outlined,
                  color: const Color(0xFF8E24AA),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VidhiListScreen())),
                ),
                _buildActionCard(
                  context,
                  title: "Festival Cards",
                  subtitle: "WhatsApp Greetings",
                  icon: Icons.palette_outlined,
                  color: const Color(0xFF2E7D32),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CardMakerScreen())),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Trending Aartis & Chalisas Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "HD Aartis & Chalisas",
                  style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    if (audioProv.tracks.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AudioPlayerScreen(track: audioProv.tracks.first),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "View Player",
                    style: GoogleFonts.poppins(color: AppTheme.marigold, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: audioProv.tracks.take(3).length,
              itemBuilder: (context, i) {
                final track = audioProv.tracks[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.sacredMaroon.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.music_note_rounded, color: AppTheme.sacredMaroon),
                    ),
                    title: Text(track.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text("${track.deity} • ${track.category}", style: GoogleFonts.poppins(fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_circle_fill, color: AppTheme.marigold, size: 34),
                      onPressed: () {
                        audioProv.playTrack(track);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AudioPlayerScreen(track: track)),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Featured Regional Vidhis
            Text(
              "Featured Regional Vidhis",
              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vidhiProv.vidhis.take(2).length,
              itemBuilder: (context, i) {
                final vidhi = vidhiProv.vidhis[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.divineGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.temple_hindu_outlined, color: AppTheme.marigold),
                    ),
                    title: Text(vidhi.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text("${vidhi.regionalTag} • ${vidhi.estimatedMinutes} mins", style: GoogleFonts.poppins(fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textMuted),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => VidhiDetailScreen(vidhi: vidhi)),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.templeCardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
