import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/app_theme.dart';
import '../providers/app_provider.dart';
import '../services/admob_service.dart';

class TempleWallpaperItem {
  final String id;
  final String templeName;
  final String location;
  final String deity;
  final String shlokaSanskrit;
  final String quoteEnglish;
  final List<Color> gradientColors;
  final String iconBadge;

  const TempleWallpaperItem({
    required this.id,
    required this.templeName,
    required this.location,
    required this.deity,
    required this.shlokaSanskrit,
    required this.quoteEnglish,
    required this.gradientColors,
    required this.iconBadge,
  });
}

class WallpaperGalleryScreen extends StatelessWidget {
  const WallpaperGalleryScreen({super.key});

  static const List<TempleWallpaperItem> wallpapers = [
    TempleWallpaperItem(
      id: 'ram_mandir',
      templeName: 'Shri Ram Janmabhoomi',
      location: 'Ayodhya Dham, Uttar Pradesh',
      deity: 'Bhagwan Shri Ram',
      shlokaSanskrit: 'मङ्गल भवन अमङ्गल हारी। द्रवहु सुदसरथ अजिर बिहारी॥',
      quoteEnglish: 'May the divine grace of Maryada Purushottam Shri Ram bring peace and prosperity.',
      gradientColors: [Color(0xFF78350F), Color(0xFFB45309), Color(0xFFF59E0B)],
      iconBadge: '🏹',
    ),
    TempleWallpaperItem(
      id: 'kashi_vishwanath',
      templeName: 'Kashi Vishwanath Dham',
      location: 'Varanasi, Uttar Pradesh',
      deity: 'Lord Shiva (Mahadev)',
      shlokaSanskrit: 'वाराणसी पुरपतेर्विशालनेत्रं, नमामि विश्वनाथं शशिशेखरं च॥',
      quoteEnglish: 'Om Namah Shivaya. May the eternal light of Kashi dispel all darkness.',
      gradientColors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
      iconBadge: '🔱',
    ),
    TempleWallpaperItem(
      id: 'kedarnath',
      templeName: 'Kedarnath Dham',
      location: 'Garhwal Himalayas, Uttarakhand',
      deity: 'Lord Shiva',
      shlokaSanskrit: 'महाद्रिपार्श्वे च तटे रमन्तं, सम्पूज्यमानं सततं मुनीन्द्रैः॥',
      quoteEnglish: 'Har Har Mahadev. Standing strong amid the snowy peaks of devotion.',
      gradientColors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0284C7)],
      iconBadge: '🏔️',
    ),
    TempleWallpaperItem(
      id: 'tirupati_balaji',
      templeName: 'Tirupati Venkateswara',
      location: 'Tirumala, Andhra Pradesh',
      deity: 'Lord Venkateswara (Govinda)',
      shlokaSanskrit: 'वेङ्कटाद्रिसमं स्थानं ब्रह्माण्डे नास्ति किञ्चन। वेङ्कटेशसमो देवो न भूतो न भविष्यति॥',
      quoteEnglish: 'Govinda Hari Govinda. Eternal wealth of devotion and boundless grace.',
      gradientColors: [Color(0xFF701A75), Color(0xFF86198F), Color(0xFFC026D3)],
      iconBadge: '🪷',
    ),
    TempleWallpaperItem(
      id: 'mahakaleshwar',
      templeName: 'Mahakaleshwar Jyotirlinga',
      location: 'Ujjain, Madhya Pradesh',
      deity: 'Lord Mahakal',
      shlokaSanskrit: 'अवन्तिकायां विहितावतारं, मुक्तिप्रदानाय च सज्जनानाम्॥',
      quoteEnglish: 'Jai Shri Mahakal. Transcending time, conquering mortality with pure bhakti.',
      gradientColors: [Color(0xFF450A0A), Color(0xFF7F1D1D), Color(0xFFB91C1C)],
      iconBadge: '🔥',
    ),
    TempleWallpaperItem(
      id: 'somnath',
      templeName: 'Shri Somnath Jyotirlinga',
      location: 'Prabhas Patan, Gujarat',
      deity: 'Lord Somnath',
      shlokaSanskrit: 'सौराष्ट्रदेशे विशदेऽतिरम्ये, ज्योतिर्मयं चन्द्रकलावतंसम्॥',
      quoteEnglish: 'First among the 12 sacred Jyotirlingas, radiant across the Arabian Sea.',
      gradientColors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF10B981)],
      iconBadge: '🌊',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "4K Temple Wallpapers & Status",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 18,
          childAspectRatio: 0.82,
        ),
        itemCount: wallpapers.length,
        itemBuilder: (context, idx) {
          final item = wallpapers[idx];
          return _buildWallpaperCard(context, item, appProv);
        },
      ),
    );
  }

  Widget _buildWallpaperCard(BuildContext context, TempleWallpaperItem item, AppProvider appProv) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: item.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: item.gradientColors.first.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle background decorative pattern
          Positioned(
            right: -20,
            bottom: -20,
            child: Text(
              item.iconBadge,
              style: TextStyle(fontSize: 140, color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        "4K ULTRA HD • DARSHAN",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                      ),
                    ),
                    Text(item.iconBadge, style: const TextStyle(fontSize: 24)),
                  ],
                ),
                const Spacer(),
                Text(
                  item.templeName,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  item.location,
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.shlokaSanskrit,
                        style: GoogleFonts.poppins(color: const Color(0xFFFEF08A), fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.quoteEnglish,
                        style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.9), fontSize: 11.5, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 14, color: AppTheme.divineGold),
                    const SizedBox(width: 6),
                    Text(
                      "Shared by: ${appProv.familyName}",
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _shareStatus(context, item, appProv),
                        icon: const Icon(Icons.share, size: 16, color: Colors.black),
                        label: Text(
                          "WhatsApp Status",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _downloadWallpaper(context, item, appProv),
                        icon: const Icon(Icons.download_rounded, size: 16, color: Colors.white),
                        label: Text(
                          "Download 4K",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _shareStatus(BuildContext context, TempleWallpaperItem item, AppProvider appProv) {
    final text = """
🙏 Darshan from ${item.templeName} (${item.location}) 🙏

${item.shlokaSanskrit}

"${item.quoteEnglish}"

✨ Shared with warm blessings by ${appProv.familyName}
📱 Download PujaVidhi - Sanatan Vedic Suite for Daily Panchang & Aartis!
""";

    SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: "${item.templeName} Darshan",
      ),
    );
  }

  void _downloadWallpaper(BuildContext context, TempleWallpaperItem item, AppProvider appProv) {
    // Rewarded ad for free users, instant for Prime
    AdMobService.showRewardedAd(
      isProUser: appProv.isProUser,
      onUserEarnedReward: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✨ High-resolution 4K wallpaper for '${item.templeName}' saved!"),
            backgroundColor: AppTheme.sacredMaroon,
          ),
        );
      },
      onDismissedWithoutReward: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Watch the complete message to download 4K wallpaper.")),
        );
      },
    );
  }
}
