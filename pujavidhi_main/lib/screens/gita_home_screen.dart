import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/app_theme.dart';
import '../models/gita_model.dart';
import '../providers/gita_provider.dart';
import '../providers/app_provider.dart';
import '../widgets/ad_banner_widget.dart';
import 'gita_chapter_screen.dart';
import 'gita_shloka_screen.dart';

class GitaHomeScreen extends StatefulWidget {
  const GitaHomeScreen({super.key});

  @override
  State<GitaHomeScreen> createState() => _GitaHomeScreenState();
}

class _GitaHomeScreenState extends State<GitaHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _topics = [
    'All',
    'Karma Yoga',
    'Bhakti',
    'Soul (आत्मा)',
    'Mind & Meditation',
    'Dharma',
    'Avatara (अवतार)',
    'Moksha & Surrender (शरणागति)',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _shareDailyVerse(BuildContext context, GitaShloka verse, AppProvider appProv) {
    final buffer = StringBuffer();
    buffer.writeln("✨ *दैनिक गीता प्रेरणा (Today's Divine Guidance)* ✨");
    buffer.writeln("📖 श्रीमद्भगवद्गीता (अध्याय ${verse.chapterNumber}, श्लोक ${verse.verseNumber})\n");
    buffer.writeln(verse.textSanskrit);
    buffer.writeln("\n_${verse.textTransliteration}_\n");
    buffer.writeln("═══════════════════════════");
    buffer.writeln("✨ *हिंदी अनुवाद:*");
    buffer.writeln(verse.translationHindi);
    if (verse.purportHindi.isNotEmpty) {
      buffer.writeln("\n💡 *भावार्थ:*");
      buffer.writeln(verse.purportHindi);
    }
    buffer.writeln("═══════════════════════════");
    buffer.writeln("🙏 Shared with warm blessings by ${appProv.familyName}");
    buffer.writeln("📱 Read all 18 Chapters of Shrimad Bhagavad Gita on PujaVidhi App!");

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: "Daily Gita Guidance",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gitaProv = Provider.of<GitaProvider>(context);
    final appProv = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final daily = gitaProv.dailyVerse;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "श्रीमद्भगवद्गीता (Bhagavad Gita)",
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.divineGold,
          labelColor: AppTheme.divineGold,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            const Tab(icon: Icon(Icons.menu_book_rounded), text: "18 अध्याय (Chapters)"),
            Tab(
              icon: const Icon(Icons.bookmark_rounded),
              text: "पसंदीदा (${gitaProv.bookmarkedIds.length})",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ==========================================
          // TAB 1: 18 CHAPTERS & SEARCH & TOPICS
          // ==========================================
          _buildChaptersTab(context, gitaProv, appProv, daily, isDark),

          // ==========================================
          // TAB 2: BOOKMARKED VERSES
          // ==========================================
          _buildBookmarksTab(context, gitaProv, appProv, isDark),
        ],
      ),
    );
  }

  Widget _buildChaptersTab(
    BuildContext context,
    GitaProvider gitaProv,
    AppProvider appProv,
    GitaShloka? daily,
    bool isDark,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            children: [
              // 1. Daily Krishna Guidance / Verse of the Day Card
              if (daily != null) ...[
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
                    border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.wb_sunny_rounded, color: AppTheme.divineGold, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "आज की दिव्य प्रेरणा (Daily Shloka)",
                                style: GoogleFonts.poppins(
                                  color: AppTheme.divineGold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "अध्याय ${daily.chapterNumber}.${daily.verseNumber}",
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        daily.textSanskrit,
                        style: GoogleFonts.martel(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        daily.translationHindi,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => GitaShlokaScreen(
                                      shloka: daily,
                                      allVersesInChapter: gitaProv.getShlokasForChapter(daily.chapterNumber),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.auto_stories_rounded, size: 16, color: Colors.white),
                              label: const Text("विस्तार से पढ़ें", style: TextStyle(color: Colors.white, fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.divineGold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.share_rounded, color: Color(0xFF25D366)),
                            tooltip: "WhatsApp Share",
                            onPressed: () => _shareDailyVerse(context, daily, appProv),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // 2. Search & Topic Filters
              TextField(
                onChanged: (val) => gitaProv.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: "Search Shloka by topic, karma, moksha (श्लोक खोजें)...",
                  hintStyle: GoogleFonts.poppins(fontSize: 12.5, color: AppTheme.textMuted),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.sacredMaroon),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.3)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Topic Filter Chips
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _topics.length,
                  itemBuilder: (context, idx) {
                    final t = _topics[idx];
                    final isSel = gitaProv.selectedTopic == t;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          t,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                        selected: isSel,
                        selectedColor: AppTheme.sacredMaroon,
                        onSelected: (_) => gitaProv.setTopic(t),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        showCheckmark: false,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),

              // If filtering by search/topic, show matching shlokas directly
              if (gitaProv.searchQuery.isNotEmpty || gitaProv.selectedTopic != 'All') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "खोज परिणाम (${gitaProv.filteredShlokas.length} श्लोक)",
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        gitaProv.setSearchQuery('');
                        gitaProv.setTopic('All');
                      },
                      child: const Text("Reset Filters", style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (gitaProv.filteredShlokas.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text("कोई श्लोक नहीं मिला। कृपया अन्य विषय खोजें।"),
                    ),
                  )
                else
                  ...gitaProv.filteredShlokas.map((s) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.25)),
                      ),
                      child: ListTile(
                        title: Text(
                          "अध्याय ${s.chapterNumber}, श्लोक ${s.verseNumber}",
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.sacredMaroon),
                        ),
                        subtitle: Text(
                          s.textSanskrit,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.martel(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.marigold),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GitaShlokaScreen(
                                shloka: s,
                                allVersesInChapter: gitaProv.getShlokasForChapter(s.chapterNumber),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
              ] else ...[
                // Default: All 18 Chapters List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "संपूर्ण १८ अध्याय (All 18 Chapters)",
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "कुल ७०० श्लोक",
                      style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.marigold, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (gitaProv.chapters.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 36),
                      child: CircularProgressIndicator(color: AppTheme.divineGold),
                    ),
                  )
                else
                  ...gitaProv.chapters.map((ch) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.25)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GitaChapterScreen(chapter: ch),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            // Chapter Number Badge
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [AppTheme.divineGold, AppTheme.sacredMaroon],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "${ch.chapterNumber}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Chapter Titles & Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ch.nameSanskrit,
                                    style: GoogleFonts.martel(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ch.nameEnglish,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${ch.versesCount} श्लोक • ${ch.keyLesson}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.5,
                                      color: isDark ? Colors.amber[200] : const Color(0xFFB45309),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppTheme.marigold),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
        const AdBannerWidget(),
      ],
    );
  }

  // --- TAB 2: BOOKMARKED VERSES ---
  Widget _buildBookmarksTab(
    BuildContext context,
    GitaProvider gitaProv,
    AppProvider appProv,
    bool isDark,
  ) {
    final bookmarks = gitaProv.bookmarkedShlokas;

    if (bookmarks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bookmark_border_rounded, size: 64, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                "कोई श्लोक सेव नहीं है",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "किसी भी श्लोक के ऊपर बुकमार्क आइकन दबाकर अपने प्रिय श्लोक यहाँ सेव करें।",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: bookmarks.length,
            itemBuilder: (context, idx) {
              final s = bookmarks[idx];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.3)),
                ),
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
                              "अध्याय ${s.chapterNumber}, श्लोक ${s.verseNumber}",
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
                                icon: const Icon(Icons.bookmark, color: AppTheme.divineGold, size: 20),
                                tooltip: "Remove Bookmark",
                                onPressed: () => gitaProv.toggleBookmark(s),
                              ),
                              IconButton(
                                icon: const Icon(Icons.share_rounded, color: Color(0xFF25D366), size: 19),
                                tooltip: "WhatsApp Share",
                                onPressed: () => _shareDailyVerse(context, s, appProv),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s.textSanskrit,
                        style: GoogleFonts.martel(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.textLight : AppTheme.sacredMaroon,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s.translationHindi,
                        style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => GitaShlokaScreen(
                                  shloka: s,
                                  allVersesInChapter: gitaProv.getShlokasForChapter(s.chapterNumber),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.menu_book_rounded, size: 14),
                          label: const Text("पूर्ण अध्ययन"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const AdBannerWidget(),
      ],
    );
  }
}
