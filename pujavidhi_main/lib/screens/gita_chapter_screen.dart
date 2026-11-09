import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/gita_model.dart';
import '../providers/gita_provider.dart';
import '../widgets/ad_banner_widget.dart';
import 'gita_shloka_screen.dart';

class GitaChapterScreen extends StatelessWidget {
  final GitaChapter chapter;

  const GitaChapterScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final gitaProv = Provider.of<GitaProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verses = gitaProv.getShlokasForChapter(chapter.chapterNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "अध्याय ${chapter.chapterNumber}: ${chapter.nameSanskrit}",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              children: [
                // Chapter Hero Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.sacredMaroon,
                        AppTheme.sacredMaroon.withValues(alpha: 0.85),
                        const Color(0xFF5A1014),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.sacredMaroon.withValues(alpha: 0.3),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.divineGold,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "अध्याय ${chapter.chapterNumber}",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Text(
                            "${chapter.versesCount} श्लोक",
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        chapter.nameSanskrit,
                        style: GoogleFonts.martel(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${chapter.nameEnglish} (${chapter.nameTranslation})",
                        style: GoogleFonts.poppins(
                          color: AppTheme.divineGold,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        chapter.summaryHindi,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 12.5,
                          height: 1.5,
                        ),
                      ),
                      if (chapter.keyLesson.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              const Text("💡", style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  chapter.keyLesson,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFFEF08A),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  verses.length >= chapter.versesCount
                      ? "संपूर्ण श्लोक संग्रह (${verses.length} श्लोक)"
                      : "श्लोक संग्रह (${verses.length} / ${chapter.versesCount} उपलब्ध)",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                if (verses.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(Icons.auto_stories_rounded, size: 48, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            "सभी ${chapter.versesCount} श्लोक शीघ्र ही उपलब्ध होंगे।",
                            style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...verses.map((v) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.25)),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GitaShlokaScreen(
                                shloka: v,
                                allVersesInChapter: verses,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppTheme.sacredMaroon.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "श्लोक ${v.verseNumber}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.sacredMaroon,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          v.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                          color: v.isBookmarked ? AppTheme.divineGold : Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () => gitaProv.toggleBookmark(v),
                                      ),
                                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.marigold),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                v.textSanskrit,
                                style: GoogleFonts.martel(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppTheme.textLight : AppTheme.sacredMaroon,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                v.translationHindi,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }
}
