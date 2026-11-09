import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/app_theme.dart';
import '../models/audio_track_model.dart';
import '../providers/app_provider.dart';
import '../widgets/ad_banner_widget.dart';

class AartiReaderScreen extends StatefulWidget {
  final AudioTrack track;

  const AartiReaderScreen({super.key, required this.track});

  @override
  State<AartiReaderScreen> createState() => _AartiReaderScreenState();
}

class _AartiReaderScreenState extends State<AartiReaderScreen> {
  double _fontSize = 17.0;
  int _viewMode = 0; // 0: Dual (Hindi + English), 1: Hindi Devanagari only, 2: English only

  void _shareAartiToWhatsApp(BuildContext context, AppProvider appProv) {
    final track = widget.track;
    final buffer = StringBuffer();
    final hindiTitle = track.hindiTitle.isNotEmpty ? track.hindiTitle : track.title;

    buffer.writeln("🪔 *$hindiTitle* 🪔");
    if (track.title.isNotEmpty && track.title != hindiTitle) {
      buffer.writeln("(${track.title})");
    }
    buffer.writeln("🙏 समर्पित: ${track.deity}");
    buffer.writeln("═══════════════════════════\n");

    for (int i = 0; i < track.lyrics.length; i++) {
      final line = track.lyrics[i];
      buffer.writeln(line.devanagari);
      if (line.english.isNotEmpty) {
        buffer.writeln("_${line.english}_");
      }
      buffer.writeln();
    }

    if (track.significance.isNotEmpty) {
      buffer.writeln("═══════════════════════════");
      buffer.writeln("✨ *महत्व व फलश्रुति:*");
      buffer.writeln(track.significance);
      buffer.writeln();
    }

    buffer.writeln("🙏 Shared with warm blessings by ${appProv.familyName}");
    buffer.writeln("📱 Read 14 Complete Vedic Aartis on PujaVidhi App!");

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: "$hindiTitle - PujaVidhi Aarti",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final track = widget.track;
    final displayName = track.hindiTitle.isNotEmpty ? track.hindiTitle : track.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          displayName,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Zoom out
          IconButton(
            icon: const Icon(Icons.text_decrease_rounded),
            tooltip: "Decrease Font Size",
            onPressed: () {
              if (_fontSize > 13) setState(() => _fontSize -= 1.5);
            },
          ),
          // Zoom in
          IconButton(
            icon: const Icon(Icons.text_increase_rounded),
            tooltip: "Increase Font Size",
            onPressed: () {
              if (_fontSize < 28) setState(() => _fontSize += 1.5);
            },
          ),
          // WhatsApp Share
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppTheme.divineGold),
            tooltip: "Share Aarti on WhatsApp",
            onPressed: () => _shareAartiToWhatsApp(context, appProv),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top sacred banner & view toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.templeCardDark : Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.sacredMaroon.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              track.deity,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.sacredMaroon,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${track.lyrics.length} छंद (Verses)",
                            style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                      if (track.title != displayName)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            track.title,
                            style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
                          ),
                        ),
                    ],
                  ),
                ),
                // Language View Filter Pill
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text("दोनों", style: TextStyle(fontSize: 11))),
                    ButtonSegment(value: 1, label: Text("हिंदी", style: TextStyle(fontSize: 11))),
                    ButtonSegment(value: 2, label: Text("Eng", style: TextStyle(fontSize: 11))),
                  ],
                  selected: {_viewMode},
                  onSelectionChanged: (set) {
                    setState(() => _viewMode = set.first);
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),

          // Main Scrollable Read-Only Aarti Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Spiritual Header Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.sacredMaroon,
                          AppTheme.sacredMaroon.withValues(alpha: 0.85),
                          const Color(0xFF5B1012),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.sacredMaroon.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.wb_sunny_rounded, color: AppTheme.divineGold, size: 36),
                        const SizedBox(height: 8),
                        Text(
                          displayName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.martel(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "समर्पित: ${track.deity}",
                          style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.divineGold),
                        ),
                        if (track.significance.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              track.significance,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // WhatsApp Big Action Button
                  ElevatedButton.icon(
                    onPressed: () => _shareAartiToWhatsApp(context, appProv),
                    icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                    label: Text(
                      "Share Full Aarti on WhatsApp (व्हाट्सएप शेयर)",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stanzas / Verses List (Pure Read-Only)
                  ...track.lyrics.asMap().entries.map((entry) {
                    final index = entry.key;
                    final line = entry.value;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.templeCardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.divineGold.withValues(alpha: 0.35),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: AppTheme.sacredMaroon.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.sacredMaroon,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "छंद ${index + 1}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16),

                          // Hindi Devanagari Lyrics
                          if (_viewMode == 0 || _viewMode == 1) ...[
                            Text(
                              line.devanagari,
                              style: GoogleFonts.martel(
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.textLight : AppTheme.sacredMaroon,
                                height: 1.6,
                              ),
                            ),
                          ],

                          // English Transliterated Lyrics
                          if (_viewMode == 0 || _viewMode == 2) ...[
                            if (_viewMode == 0) const SizedBox(height: 8),
                            Text(
                              line.english,
                              style: GoogleFonts.poppins(
                                fontSize: (_fontSize - 3).clamp(11.0, 22.0),
                                fontStyle: FontStyle.italic,
                                color: isDark ? Colors.grey[400] : Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 10),

                  // Bottom WhatsApp Share
                  ElevatedButton.icon(
                    onPressed: () => _shareAartiToWhatsApp(context, appProv),
                    icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                    label: Text(
                      "Share Aarti with Family & Friends",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Ad Banner
          const AdBannerWidget(),
        ],
      ),
    );
  }
}
