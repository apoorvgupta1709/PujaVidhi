import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/app_theme.dart';
import '../models/audio_track_model.dart';
import '../providers/audio_provider.dart';
import '../providers/app_provider.dart';
import '../widgets/ad_banner_widget.dart';
import 'aarti_reader_screen.dart';

class AartiListScreen extends StatefulWidget {
  const AartiListScreen({super.key});

  @override
  State<AartiListScreen> createState() => _AartiListScreenState();
}

class _AartiListScreenState extends State<AartiListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Ganesha',
    'Shiva',
    'Hanuman',
    'Vishnu & Krishna',
    'Devi Maa',
    'Surya & Shani',
  ];

  bool _matchesCategory(AudioTrack track, String cat) {
    if (cat == 'All') return true;
    final d = track.deity.toLowerCase();
    final t = track.title.toLowerCase();
    final ht = track.hindiTitle.toLowerCase();

    if (cat == 'Ganesha') return d.contains('ganesh') || t.contains('ganesh') || ht.contains('गणेश');
    if (cat == 'Shiva') return d.contains('shiv') || d.contains('bholenath') || t.contains('shiv') || ht.contains('शिव');
    if (cat == 'Hanuman') return d.contains('hanuman') || t.contains('hanuman') || ht.contains('हनुमान');
    if (cat == 'Vishnu & Krishna') {
      return d.contains('vishnu') || d.contains('krishna') || d.contains('ram') || d.contains('jagdish') || d.contains('shyam') || ht.contains('विष्णु') || ht.contains('कृष्ण') || ht.contains('राम');
    }
    if (cat == 'Devi Maa') {
      return d.contains('durga') || d.contains('lakshmi') || d.contains('saraswati') || d.contains('gayatri') || d.contains('ganga') || ht.contains('दुर्गा') || ht.contains('लक्ष्मी') || ht.contains('सरस्वती') || ht.contains('गंगा');
    }
    if (cat == 'Surya & Shani') {
      return d.contains('surya') || d.contains('shani') || ht.contains('सूर्य') || ht.contains('शनि');
    }
    return true;
  }

  void _shareQuickAarti(BuildContext context, AudioTrack track, AppProvider appProv) {
    final buffer = StringBuffer();
    final displayName = track.hindiTitle.isNotEmpty ? track.hindiTitle : track.title;

    buffer.writeln("🪔 *$displayName* 🪔");
    if (track.title.isNotEmpty && track.title != displayName) {
      buffer.writeln("(${track.title})");
    }
    buffer.writeln("🙏 समर्पित: ${track.deity}\n");

    for (int i = 0; i < track.lyrics.length; i++) {
      buffer.writeln(track.lyrics[i].devanagari);
      if (track.lyrics[i].english.isNotEmpty) {
        buffer.writeln("_${track.lyrics[i].english}_");
      }
      buffer.writeln();
    }

    if (track.significance.isNotEmpty) {
      buffer.writeln("✨ *महत्व:* ${track.significance}\n");
    }

    buffer.writeln("🙏 Shared with warm blessings by ${appProv.familyName}");
    buffer.writeln("📱 Read 14 Complete Vedic Aartis on PujaVidhi App!");

    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: "$displayName - Aarti",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioProv = Provider.of<AudioProvider>(context);
    final appProv = Provider.of<AppProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredTracks = audioProv.tracks.where((t) {
      final matchesCat = _matchesCategory(t, _selectedCategory);
      if (!matchesCat) return false;

      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return t.title.toLowerCase().contains(q) ||
          t.hindiTitle.toLowerCase().contains(q) ||
          t.deity.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aartis & Stutis (आरती संग्रह)",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search & Category Filters
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: isDark ? AppTheme.templeCardDark : Colors.white,
            child: Column(
              children: [
                // Search Input
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: "Search Aarti by deity, name (आरती खोजें)...",
                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textMuted),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.sacredMaroon),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? Colors.black26 : const Color(0xFFF9F5F0),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Category Chips
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _categories.length,
                    itemBuilder: (context, idx) {
                      final cat = _categories[idx];
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            cat,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.white : (isDark ? AppTheme.textLight : AppTheme.textDark),
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedCategory = cat),
                          backgroundColor: isDark ? AppTheme.templeCardDark : Colors.grey.withValues(alpha: 0.1),
                          selectedColor: AppTheme.sacredMaroon,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          showCheckmark: false,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Count Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${filteredTracks.length} Aartis Available",
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted),
                ),
                Text(
                  "📖 Read-Only & WhatsApp Shareable",
                  style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.marigold, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          // List of Aartis
          Expanded(
            child: filteredTracks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.menu_book_rounded, size: 56, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          "No Aartis found",
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Try searching for another deity or filter",
                          style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredTracks.length,
                    itemBuilder: (context, idx) {
                      final track = filteredTracks[idx];
                      final displayName = track.hindiTitle.isNotEmpty ? track.hindiTitle : track.title;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: AppTheme.divineGold.withValues(alpha: 0.25),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AartiReaderScreen(track: track),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                // Sacred Diya Icon Badge
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [AppTheme.divineGold, AppTheme.sacredMaroon],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.sacredMaroon.withValues(alpha: 0.25),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 24),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Aarti Titles & Deity
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: GoogleFonts.martel(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (track.title != displayName)
                                        Text(
                                          track.title,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: AppTheme.textMuted,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.sacredMaroon.withValues(alpha: 0.08),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              track.deity,
                                              style: GoogleFonts.poppins(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.sacredMaroon,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "${track.lyrics.length} छंद",
                                            style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Actions Column: Read Button & WhatsApp Share
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => AartiReaderScreen(track: track),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.sacredMaroon,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.menu_book_rounded, size: 14, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text("पढ़ें", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    IconButton(
                                      icon: const Icon(Icons.share_rounded, size: 19, color: Color(0xFF25D366)),
                                      tooltip: "WhatsApp Share",
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => _shareQuickAarti(context, track, appProv),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Bottom Ad Banner
          const AdBannerWidget(),
        ],
      ),
    );
  }
}
