import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/app_theme.dart';
import '../models/gita_model.dart';
import '../providers/gita_provider.dart';
import '../providers/app_provider.dart';
import '../widgets/ad_banner_widget.dart';

class GitaShlokaScreen extends StatefulWidget {
  final GitaShloka shloka;
  final List<GitaShloka> allVersesInChapter;

  const GitaShlokaScreen({
    super.key,
    required this.shloka,
    this.allVersesInChapter = const [],
  });

  @override
  State<GitaShlokaScreen> createState() => _GitaShlokaScreenState();
}

class _GitaShlokaScreenState extends State<GitaShlokaScreen> {
  late GitaShloka _currentShloka;
  late int _currentIndex;
  double _fontSize = 17.0;

  @override
  void initState() {
    super.initState();
    _currentShloka = widget.shloka;
    _currentIndex = widget.allVersesInChapter.indexWhere((s) => s.id == _currentShloka.id);
    if (_currentIndex == -1) _currentIndex = 0;
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _currentShloka = widget.allVersesInChapter[_currentIndex];
      });
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.allVersesInChapter.length - 1) {
      setState(() {
        _currentIndex++;
        _currentShloka = widget.allVersesInChapter[_currentIndex];
      });
    }
  }

  void _shareShlokaToWhatsApp(BuildContext context, GitaShloka s, AppProvider appProv) {
    final buffer = StringBuffer();
    buffer.writeln("📖 *श्रीमद्भगवद्गीता (अध्याय ${s.chapterNumber}, श्लोक ${s.verseNumber})* 📖\n");
    buffer.writeln(s.textSanskrit);
    buffer.writeln("\n_${s.textTransliteration}_\n");
    buffer.writeln("═══════════════════════════");
    buffer.writeln("✨ *हिंदी अनुवाद:*");
    buffer.writeln(s.translationHindi);
    if (s.purportHindi.isNotEmpty) {
      buffer.writeln("\n💡 *भावार्थ:*");
      buffer.writeln(s.purportHindi);
    }
    buffer.writeln("═══════════════════════════");
    buffer.writeln("🙏 Shared with warm blessings by ${appProv.familyName}");
    buffer.writeln("📱 Read all 18 Chapters of Shrimad Bhagavad Gita on PujaVidhi App!");

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: "Gita Ch ${s.chapterNumber} Verse ${s.verseNumber}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gitaProv = Provider.of<GitaProvider>(context);
    final appProv = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = _currentShloka;

    final hasPrev = _currentIndex > 0;
    final hasNext = _currentIndex < widget.allVersesInChapter.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "अध्याय ${s.chapterNumber}, श्लोक ${s.verseNumber}",
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease),
            tooltip: "Decrease Font Size",
            onPressed: () {
              if (_fontSize > 13) setState(() => _fontSize -= 1.5);
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            tooltip: "Increase Font Size",
            onPressed: () {
              if (_fontSize < 28) setState(() => _fontSize += 1.5);
            },
          ),
          IconButton(
            icon: Icon(
              s.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: s.isBookmarked ? AppTheme.divineGold : Colors.white,
            ),
            tooltip: s.isBookmarked ? "Bookmarked" : "Bookmark Verse",
            onPressed: () => gitaProv.toggleBookmark(s),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppTheme.divineGold),
            tooltip: "Share to WhatsApp",
            onPressed: () => _shareShlokaToWhatsApp(context, s, appProv),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Sanskrit Verse Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.sacredMaroon,
                          AppTheme.sacredMaroon.withValues(alpha: 0.85),
                          const Color(0xFF4A0E10),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.sacredMaroon.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: AppTheme.divineGold.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                s.topicTag,
                                style: GoogleFonts.poppins(
                                  color: AppTheme.divineGold,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "॥ श्रीमद्भगवद्गीता ॥",
                              style: GoogleFonts.martel(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          s.textSanskrit,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.martel(
                            fontSize: _fontSize + 1,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          s.textTransliteration,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: (_fontSize - 3).clamp(11.0, 22.0),
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFFFEF08A),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // WhatsApp Action Button
                  ElevatedButton.icon(
                    onPressed: () => _shareShlokaToWhatsApp(context, s, appProv),
                    icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                    label: Text(
                      "Share Shloka on WhatsApp (व्हाट्सएप शेयर)",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Word Meanings (पदच्छेद एवं शब्दार्थ)
                  if (s.wordMeanings.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.templeCardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.translate_rounded, color: AppTheme.marigold, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                "पदच्छेद एवं शब्दार्थ (Word-by-Word)",
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Text(
                            s.wordMeanings,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: isDark ? Colors.grey[300] : Colors.grey[800],
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Hindi Translation (अनुवाद)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.templeCardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_stories_rounded, color: AppTheme.sacredMaroon, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "हिंदी अनुवाद (Hindi Translation)",
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Text(
                          s.translationHindi,
                          style: GoogleFonts.martel(
                            fontSize: _fontSize - 1,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.textLight : AppTheme.sacredMaroon,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Hindi Purport / Bhavarth (भावार्थ)
                  if (s.purportHindi.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.templeCardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.wb_sunny_rounded, color: AppTheme.divineGold, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                "भावार्थ एवं आध्यात्मिक रहस्य (Purport)",
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Text(
                            s.purportHindi,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: isDark ? Colors.grey[300] : Colors.grey[800],
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // English Translation
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.templeCardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.language_rounded, color: Color(0xFF0284C7), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "English Translation",
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Text(
                          s.translationEnglish,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Previous / Next Verse Bottom Toolbar
          if (widget.allVersesInChapter.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.templeCardDark : Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: hasPrev ? _goToPrevious : null,
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
                    label: const Text("पिछला श्लोक"),
                  ),
                  Text(
                    "${_currentIndex + 1} / ${widget.allVersesInChapter.length}",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  TextButton.icon(
                    onPressed: hasNext ? _goToNext : null,
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    label: const Text("अगला श्लोक"),
                  ),
                ],
              ),
            ),

          const AdBannerWidget(),
        ],
      ),
    );
  }
}
