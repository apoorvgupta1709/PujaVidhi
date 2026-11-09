import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/app_theme.dart';
import '../models/wallpaper_model.dart';
import '../providers/app_provider.dart';
import '../providers/wallpaper_provider.dart';
import '../services/admob_service.dart';
import '../widgets/ad_banner_widget.dart';

class WallpaperGalleryScreen extends StatefulWidget {
  final int initialTabIndex;

  const WallpaperGalleryScreen({super.key, this.initialTabIndex = 0});

  @override
  State<WallpaperGalleryScreen> createState() => _WallpaperGalleryScreenState();
}

class _WallpaperGalleryScreenState extends State<WallpaperGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- STUDIO & BUILDER STATE ---
  final GlobalKey _canvasKey = GlobalKey();
  final TextEditingController _senderCtrl = TextEditingController();
  final TextEditingController _quoteCtrl = TextEditingController();

  // Canvas Format: 0: 9:16 (Phone Wallpaper/Status), 1: 1:1 (Festival Card), 2: 4:5 (Devotional Post)
  int _selectedFormat = 0;

  // Background Mode: 0: God HD Wallpaper, 1: Gradient Color Theme, 2: Custom Gallery Photo
  int _backgroundMode = 0;
  DevotionalWallpaper? _activeGodWallpaper;
  double _backgroundDarkness = 0.45;

  // Gradient Background Themes
  int _selectedThemeIndex = 0;
  final List<Map<String, dynamic>> _studioThemes = [
    {
      "name": "Ayodhya Gold",
      "colors": [const Color(0xFF78350F), const Color(0xFFB45309), const Color(0xFFF59E0B)],
      "accent": const Color(0xFFFEF08A),
    },
    {
      "name": "Sacred Crimson",
      "colors": [const Color(0xFF7E191B), const Color(0xFF4A0E10), const Color(0xFF2A0507)],
      "accent": const Color(0xFFFFD700),
    },
    {
      "name": "Shiv Twilight",
      "colors": [const Color(0xFF1E1B4B), const Color(0xFF312E81), const Color(0xFF4338CA)],
      "accent": const Color(0xFF93C5FD),
    },
    {
      "name": "Marigold Saffron",
      "colors": [const Color(0xFFC2410C), const Color(0xFFEA580C), const Color(0xFFF97316)],
      "accent": Colors.white,
    },
    {
      "name": "Himalayan Snow",
      "colors": [const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFF0284C7)],
      "accent": const Color(0xFFE0F2FE),
    },
    {
      "name": "Devi Green",
      "colors": [const Color(0xFF14532D), const Color(0xFF15803D), const Color(0xFF16A34A)],
      "accent": const Color(0xFFFEF08A),
    },
  ];

  // God Photo / Emblem Selection
  int _selectedDeityIndex = 0;
  final List<Map<String, String>> _deities = [
    {"name": "Shri Ram", "symbol": "🏹", "shloka": "मङ्गल भवन अमङ्गल हारी। द्रवहु सुदसरथ अजिर बिहारी॥"},
    {"name": "Mahadev Shiva", "symbol": "🔱", "shloka": "कर्पूरगौरं करुणावतारं संसारसारम् भुजगेन्द्रहारम्॥"},
    {"name": "Shri Ganesh", "symbol": "🪔", "shloka": "वक्रतुण्ड महाकाय सूर्यकोटि समप्रभ। निर्विघ्नं कुरु मे देव॥"},
    {"name": "Shri Krishna", "symbol": "🦚", "shloka": "हरे कृष्ण हरे कृष्ण कृष्ण कृष्ण हरे हरे। हरे राम हरे राम राम राम हरे हरे॥"},
    {"name": "Hanuman Ji", "symbol": "🚩", "shloka": "मनोजवं मारुततुल्यवेगं जितेन्द्रियं बुद्धिमतां वरिष्ठम्॥"},
    {"name": "Maa Durga", "symbol": "🌺", "shloka": "सर्वमङ्गलमाङ्गल्ये शिवे सर्वार्थसाधिके। शरण्ये त्र्यम्बके गौरि नारायणि नमोऽस्तु ते॥"},
    {"name": "Maa Lakshmi", "symbol": "🪙", "shloka": "ॐ श्रीं ह्रीं क्लीं त्रिभुवन महालक्ष्म्यै अस्मांक दारिद्र्य नाशय प्रसीद प्रसीद॥"},
    {"name": "Surya Dev", "symbol": "☀️", "shloka": "ॐ भूर्भुवः स्वः तत्सवितुर्वरेण्यं भर्गो देवस्य धीमहि धियो यो नः प्रचोदयात्॥"},
  ];

  // Preset Quotes & Greetings
  final List<Map<String, String>> _presetQuotes = [
    {"title": "Morning Suvichar", "text": "सुप्रभात! आपका आज का दिन ईश्वर की असीम कृपा से सुख, शांति और स्वास्थ्य से परिपूर्ण हो।"},
    {"title": "Shubh Deepawali", "text": "दीपावली की हार्दिक शुभकामनाएं! माँ लक्ष्मी आपके घर को धन, धान्य और प्रकाश से आलोकित करें।"},
    {"title": "Maha Shivratri", "text": "महाशिवरात्रि की मंगलमय शुभकामनाएं! देवाधिदेव महादेव आपके समस्त कष्टों का हरण करें।"},
    {"title": "Jai Shri Ram", "text": "प्रभु श्री राम की कृपा आपके जीवन के हर पथ को आलोकित करे। जय श्री राम!"},
    {"title": "Chhath Mahaparva", "text": "छठ महापर्व की पावन शुभकामनाएं! सूर्य देव और छठी मैया आपको उत्तम स्वास्थ्य और दीर्घायु प्रदान करें।"},
    {"title": "Ganesh Chaturthi", "text": "गणपति बाप्पा मोरया! रिद्धि-सिद्धि के दाता आपके समस्त विघ्नों को दूर कर शुभता प्रदान करें।"},
  ];

  // Custom User Photo / God Photo picked from device
  String? _userCustomPhotoPath;
  String? _customBackgroundPhotoPath;

  // Typography Controls
  double _quoteFontSize = 14.0;
  int _selectedFontFamily = 0; // 0: Martel, 1: Rozha One, 2: Poppins, 3: Cinzel
  int _selectedColorIndex = 0;
  final List<Color> _textColors = [
    Colors.white,
    const Color(0xFFFEF08A), // Divine Gold
    const Color(0xFFFFD54F), // Amber
    const Color(0xFFFFE0B2), // Soft Saffron
    const Color(0xFFE0F2FE), // Celestial Blue
  ];

  bool _watermarkRemovedThisSession = false;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categoryFilterList = [
    'All',
    'Shiva',
    'Ram',
    'Krishna',
    'Ganesha',
    'Hanuman',
    'Devi',
    'Vishnu',
    'Surya',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    final appProv = Provider.of<AppProvider>(context, listen: false);
    _senderCtrl.text = appProv.familyName;
    _quoteCtrl.text = _deities[_selectedDeityIndex]["shloka"]!;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _senderCtrl.dispose();
    _quoteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickUserPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) {
        setState(() => _userCustomPhotoPath = image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gallery notice: $e")));
      }
    }
  }

  Future<void> _pickCustomBackgroundPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
      if (image != null) {
        setState(() {
          _customBackgroundPhotoPath = image.path;
          _backgroundMode = 2;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gallery notice: $e")));
      }
    }
  }

  Future<void> _exportAndShare4kCard({required bool saveOnly}) async {
    try {
      RenderRepaintBoundary? boundary =
          _canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // Ultra-HD 4K Rendering (3.5x scale multiplier)
      ui.Image image = await boundary.toImage(pixelRatio: 3.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final buffer = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/pujavidhi_4k_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(buffer);

      if (saveOnly) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✅ 4K Ultra-HD Image saved to: ${file.path}"),
              backgroundColor: Colors.green[800],
            ),
          );
        }
      } else {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text:
                "🙏 Divine blessings from ${_senderCtrl.text.isEmpty ? 'Devotee Family' : _senderCtrl.text}\n📱 Created with PujaVidhi - Sanatan Vedic Suite",
            subject: "PujaVidhi 4K Darshan",
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error exporting 4K image: $e")),
        );
      }
    }
  }

  TextStyle _getSelectedTextStyle(Color color, double size) {
    switch (_selectedFontFamily) {
      case 0:
        return GoogleFonts.martel(fontSize: size, fontWeight: FontWeight.bold, color: color, height: 1.5);
      case 1:
        return GoogleFonts.rozhaOne(fontSize: size + 2, fontWeight: FontWeight.bold, color: color, height: 1.4);
      case 2:
        return GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.w600, color: color, height: 1.4);
      case 3:
      default:
        return GoogleFonts.cinzel(fontSize: size, fontWeight: FontWeight.bold, color: color, height: 1.4);
    }
  }

  void _editInStudio(DevotionalWallpaper wp) {
    setState(() {
      _activeGodWallpaper = wp;
      _backgroundMode = 0;
      if (wp.mantraSanskrit.isNotEmpty) {
        _quoteCtrl.text = wp.mantraSanskrit;
      }
    });
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);
    final wallpaperProv = Provider.of<WallpaperProvider>(context);
    final isPro = appProv.isProUser || _watermarkRemovedThisSession;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Default active wallpaper if not selected
    if (_activeGodWallpaper == null && wallpaperProv.wallpapers.isNotEmpty) {
      _activeGodWallpaper = wallpaperProv.wallpapers.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "4K Wallpaper & Card Studio",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.divineGold,
          labelColor: AppTheme.divineGold,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(
              icon: const Icon(Icons.photo_library_outlined),
              text: "4K Wallpapers (${wallpaperProv.wallpapers.length})",
            ),
            const Tab(icon: Icon(Icons.brush_rounded), text: "Studio & Card Maker"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: 4K TEMPLE & GOD WALLPAPERS GALLERY
          _buildWallpapersGalleryTab(context, wallpaperProv, isDark),

          // TAB 2: STUDIO & DEVOTIONAL CARD MAKER
          _buildStudioTab(context, appProv, wallpaperProv, isPro, isDark),
        ],
      ),
    );
  }

  // --- TAB 1: WALLPAPER GALLERY ---
  Widget _buildWallpapersGalleryTab(
      BuildContext context, WallpaperProvider wallpaperProv, bool isDark) {
    final wallpapers = wallpaperProv.filteredWallpapers;

    return Column(
      children: [
        // Category Filter Chips
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: isDark ? AppTheme.templeCardDark : Colors.white,
          child: SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _categoryFilterList.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final cat = _categoryFilterList[idx];
                final isSelected = wallpaperProv.selectedCategory.toLowerCase() == cat.toLowerCase();
                return ChoiceChip(
                  label: Text(
                    cat == 'All' ? 'सभी देव (All)' : cat,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.black : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.divineGold,
                  onSelected: (val) {
                    if (val) wallpaperProv.setCategory(cat);
                  },
                );
              },
            ),
          ),
        ),

        // Wallpaper List
        Expanded(
          child: wallpapers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wallpaper, size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        "No wallpapers found in this category",
                        style: GoogleFonts.poppins(color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: wallpapers.length,
                  itemBuilder: (context, idx) {
                    final item = wallpapers[idx];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppTheme.divineGold.withValues(alpha: 0.3),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 3,
                      child: Column(
                        children: [
                          // Visual 4K Card Banner with High-Res Background Image
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: item.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Background network image with graceful fallback
                                if (item.imageUrl.isNotEmpty)
                                  Positioned.fill(
                                    child: Image.network(
                                      item.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                                    ),
                                  ),

                                // Dark Vignette Gradient Overlay so text pops
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withValues(alpha: 0.35),
                                          Colors.black.withValues(alpha: 0.75),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ),

                                // Sacred Emblem Badge
                                Positioned(
                                  right: 12,
                                  top: 12,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.6)),
                                    ),
                                    child: Text(item.iconBadge, style: const TextStyle(fontSize: 20)),
                                  ),
                                ),

                                // Content
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.5),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.5)),
                                            ),
                                            child: Text(
                                              item.deity,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: AppTheme.divineGold,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "4K ULTRA HD",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (item.category.isNotEmpty)
                                            Text(
                                              "${item.downloadsCount} Devotees Downloaded",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white70,
                                                fontSize: 11,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Shloka & Actions
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.mantraSanskrit.isNotEmpty) ...[
                                  Text(
                                    item.mantraSanskrit,
                                    style: GoogleFonts.martel(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppTheme.textLight : AppTheme.sacredMaroon,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                if (item.quoteEnglish.isNotEmpty) ...[
                                  Text(
                                    "\"${item.quoteEnglish}\"",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      fontStyle: FontStyle.italic,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _editInStudio(item),
                                        icon: const Icon(Icons.edit_note, size: 18),
                                        label: const Text("Edit in Studio", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.sacredMaroon,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.share_rounded, color: Color(0xFF25D366)),
                                      tooltip: "Share to WhatsApp",
                                      onPressed: () {
                                        SharePlus.instance.share(
                                          ShareParams(
                                            text: "🕉️ *${item.title}*\n${item.mantraSanskrit}\n\n${item.imageUrl}\n\n🙏 Shared via PujaVidhi App",
                                            subject: item.title,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        const AdBannerWidget(),
      ],
    );
  }

  // --- TAB 2: PRO STUDIO & CARD MAKER ---
  Widget _buildStudioTab(
    BuildContext context,
    AppProvider appProv,
    WallpaperProvider wallpaperProv,
    bool isPro,
    bool isDark,
  ) {
    final activeTheme = _studioThemes[_selectedThemeIndex];
    final activeDeity = _deities[_selectedDeityIndex];
    final selectedTextColor = _textColors[_selectedColorIndex];
    final wallpapers = wallpaperProv.wallpapers;

    // Determine Canvas Dimensions based on Format
    double canvasWidth = 320;
    double canvasHeight = 440; // 9:16 portrait
    if (_selectedFormat == 1) {
      canvasHeight = 320; // 1:1 Square
    } else if (_selectedFormat == 2) {
      canvasHeight = 380; // 4:5 Post
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. LIVE PREVIEW CANVAS
          Center(
            child: RepaintBoundary(
              key: _canvasKey,
              child: Container(
                width: canvasWidth,
                height: canvasHeight,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  // Background Image: God HD wallpaper or User gallery photo
                  image: (_backgroundMode == 0 && _activeGodWallpaper != null && _activeGodWallpaper!.imageUrl.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(_activeGodWallpaper!.imageUrl),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: _backgroundDarkness),
                            BlendMode.darken,
                          ),
                        )
                      : (_backgroundMode == 2 && _customBackgroundPhotoPath != null)
                          ? DecorationImage(
                              image: FileImage(File(_customBackgroundPhotoPath!)),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withValues(alpha: _backgroundDarkness),
                                BlendMode.darken,
                              ),
                            )
                          : null,
                  // Gradient fallback
                  gradient: _backgroundMode == 1
                      ? LinearGradient(
                          colors: activeTheme["colors"] as List<Color>,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : (_backgroundMode == 0 && _activeGodWallpaper != null)
                          ? LinearGradient(
                              colors: _activeGodWallpaper!.gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: (activeTheme["accent"] as Color).withValues(alpha: 0.7),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Row: Sacred Corner Diyas & Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("🪔", style: TextStyle(fontSize: 22)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: (activeTheme["accent"] as Color).withValues(alpha: 0.6),
                            ),
                          ),
                          child: Text(
                            "॥ ॐ नमः शिवाय ॥",
                            style: GoogleFonts.martel(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: activeTheme["accent"] as Color,
                            ),
                          ),
                        ),
                        const Text("🪔", style: TextStyle(fontSize: 22)),
                      ],
                    ),

                    // Central Visual: God Photo / Custom User Photo & Sacred Emblem
                    Column(
                      children: [
                        // Built-in Deity Emblem / Icon
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                (activeTheme["accent"] as Color).withValues(alpha: 0.9),
                                Colors.black54,
                              ],
                            ),
                            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
                            border: Border.all(color: activeTheme["accent"] as Color, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              _backgroundMode == 0 && _activeGodWallpaper != null
                                  ? _activeGodWallpaper!.iconBadge
                                  : activeDeity["symbol"]!,
                              style: const TextStyle(fontSize: 34),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _backgroundMode == 0 && _activeGodWallpaper != null
                              ? _activeGodWallpaper!.title
                              : activeDeity["name"]!,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: activeTheme["accent"] as Color,
                            shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                          ),
                        ),
                      ],
                    ),

                    // Middle: Quote / Shloka Overlay
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (activeTheme["accent"] as Color).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        _quoteCtrl.text.trim().isEmpty
                            ? activeDeity["shloka"]!
                            : _quoteCtrl.text.trim(),
                        textAlign: TextAlign.center,
                        style: _getSelectedTextStyle(selectedTextColor, _quoteFontSize),
                      ),
                    ),

                    // Bottom Row: Family / User Photo + Name Badge + Watermark
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_userCustomPhotoPath != null) ...[
                          Container(
                            width: 38,
                            height: 38,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: activeTheme["accent"] as Color,
                                width: 1.5,
                              ),
                              image: DecorationImage(
                                image: FileImage(File(_userCustomPhotoPath!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (activeTheme["accent"] as Color).withValues(alpha: 0.6),
                                ),
                              ),
                              child: Text(
                                "सप्रेम भेंट: ${_senderCtrl.text.trim().isEmpty ? 'Sharma Family' : _senderCtrl.text.trim()}",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: activeTheme["accent"] as Color,
                                ),
                              ),
                            ),
                            if (!isPro)
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  "PujaVidhi - Sanatan Vedic Suite",
                                  style: GoogleFonts.poppins(
                                    fontSize: 8.5,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          // 2. CANVAS FORMAT SELECTOR
          Text(
            "1. Canvas Format / Dimension",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text("4K Status (9:16)", style: TextStyle(fontSize: 11.5))),
              ButtonSegment(value: 1, label: Text("Square (1:1)", style: TextStyle(fontSize: 11.5))),
              ButtonSegment(value: 2, label: Text("Post (4:5)", style: TextStyle(fontSize: 11.5))),
            ],
            selected: {_selectedFormat},
            onSelectionChanged: (set) => setState(() => _selectedFormat = set.first),
          ),

          const SizedBox(height: 20),

          // 3. BACKGROUND MODE SELECTOR
          Text(
            "2. Select Background Wallpaper (पृष्ठभूमि चयन)",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text("🔱 God Wallpapers", style: TextStyle(fontSize: 11))),
              ButtonSegment(value: 1, label: Text("🎨 Gradient Colors", style: TextStyle(fontSize: 11))),
              ButtonSegment(value: 2, label: Text("📷 Custom Pic", style: TextStyle(fontSize: 11))),
            ],
            selected: {_backgroundMode},
            onSelectionChanged: (set) => setState(() => _backgroundMode = set.first),
          ),

          const SizedBox(height: 12),

          // Mode 0: God Wallpapers Carousel
          if (_backgroundMode == 0) ...[
            SizedBox(
              height: 115,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: wallpapers.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, idx) {
                  final wp = wallpapers[idx];
                  final isSelected = _activeGodWallpaper?.id == wp.id;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _activeGodWallpaper = wp;
                        if (wp.mantraSanskrit.isNotEmpty) {
                          _quoteCtrl.text = wp.mantraSanskrit;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppTheme.divineGold : Colors.grey.withValues(alpha: 0.3),
                          width: isSelected ? 2.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: AppTheme.divineGold.withValues(alpha: 0.4), blurRadius: 8)]
                            : null,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              wp.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                decoration: BoxDecoration(gradient: LinearGradient(colors: wp.gradientColors)),
                                child: Center(child: Text(wp.iconBadge, style: const TextStyle(fontSize: 24))),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.transparent, Colors.black87],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            left: 4,
                            right: 4,
                            child: Text(
                              wp.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Darkness slider
            Row(
              children: [
                const Icon(Icons.brightness_medium, size: 16, color: AppTheme.marigold),
                const SizedBox(width: 8),
                Text(
                  "Background Shade: ${(_backgroundDarkness * 100).toInt()}%",
                  style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
                ),
                Expanded(
                  child: Slider(
                    value: _backgroundDarkness,
                    min: 0.15,
                    max: 0.75,
                    activeColor: AppTheme.divineGold,
                    onChanged: (val) => setState(() => _backgroundDarkness = val),
                  ),
                ),
              ],
            ),
          ],

          // Mode 1: Gradient Theme Palette
          if (_backgroundMode == 1) ...[
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _studioThemes.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, idx) {
                  final theme = _studioThemes[idx];
                  final isSelected = _selectedThemeIndex == idx;
                  return InkWell(
                    onTap: () => setState(() => _selectedThemeIndex = idx),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: theme["colors"] as List<Color>),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: [
                          if (isSelected) BoxShadow(color: AppTheme.divineGold.withValues(alpha: 0.6), blurRadius: 6),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Mode 2: Custom Gallery Background
          if (_backgroundMode == 2) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickCustomBackgroundPhoto,
                    icon: const Icon(Icons.add_photo_alternate, color: AppTheme.divineGold),
                    label: Text(
                      _customBackgroundPhotoPath != null ? "Change Custom Photo" : "Upload Photo for Background",
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                if (_customBackgroundPhotoPath != null)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => setState(() => _customBackgroundPhotoPath = null),
                  ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // 4. USER OVERLAY PHOTO (FAMILY PHOTO BADGE)
          Text(
            "3. Add Your Family Photo Badge",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickUserPhoto,
                  icon: Icon(
                    _userCustomPhotoPath != null ? Icons.check_circle : Icons.person_add,
                    color: _userCustomPhotoPath != null ? Colors.green : AppTheme.marigold,
                    size: 18,
                  ),
                  label: Text(
                    _userCustomPhotoPath != null ? "Change Family Photo" : "Add Family / Devotee Photo",
                    style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              if (_userCustomPhotoPath != null)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => setState(() => _userCustomPhotoPath = null),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // 5. DEITY SELECTION
          Text(
            "4. Select Deity Emblem (इष्टदेव प्रतीक)",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _deities.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final d = _deities[idx];
                final isSelected = _selectedDeityIndex == idx;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(d["symbol"]!, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(d["name"]!, style: GoogleFonts.poppins(fontSize: 12)),
                    ],
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.divineGold,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        _selectedDeityIndex = idx;
                        _quoteCtrl.text = d["shloka"]!;
                      });
                    }
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // 6. GREETINGS & SHLOKA TEXT
          Text(
            "5. Shloka / Mantra / Festival Wishes",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          // Preset greetings horizontal chip carousel
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _presetQuotes.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final q = _presetQuotes[idx];
                return ActionChip(
                  label: Text(q["title"]!, style: GoogleFonts.poppins(fontSize: 11)),
                  backgroundColor: AppTheme.sacredMaroon.withValues(alpha: 0.1),
                  side: BorderSide(color: AppTheme.divineGold.withValues(alpha: 0.4)),
                  onPressed: () {
                    setState(() => _quoteCtrl.text = q["text"]!);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _quoteCtrl,
            maxLines: 3,
            onChanged: (val) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Enter custom Sanskrit shloka, greeting, or family blessings...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDark ? AppTheme.templeCardDark : Colors.grey[50],
            ),
          ),

          const SizedBox(height: 20),

          // 7. TYPOGRAPHY CONTROLS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "6. Typography & Font Style",
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                "Size: ${_quoteFontSize.toInt()}",
                style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
          Slider(
            value: _quoteFontSize,
            min: 11,
            max: 22,
            activeColor: AppTheme.divineGold,
            onChanged: (val) => setState(() => _quoteFontSize = val),
          ),

          // Font Selector Chips
          Row(
            children: [
              _buildFontChip("Martel (वैदिक)", 0),
              const SizedBox(width: 8),
              _buildFontChip("Rozha (शाही)", 1),
              const SizedBox(width: 8),
              _buildFontChip("Poppins (आधुनिक)", 2),
              const SizedBox(width: 8),
              _buildFontChip("Cinzel", 3),
            ],
          ),

          const SizedBox(height: 12),

          // Text Color Palette
          Row(
            children: [
              Text("Color: ", style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textMuted)),
              const SizedBox(width: 8),
              ...List.generate(_textColors.length, (idx) {
                final color = _textColors[idx];
                final isSelected = _selectedColorIndex == idx;
                return InkWell(
                  onTap: () => setState(() => _selectedColorIndex = idx),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppTheme.divineGold : Colors.grey.withValues(alpha: 0.5),
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 20),

          // 8. SENDER FAMILY NAME
          Text(
            "7. Sender / Family Name",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _senderCtrl,
            onChanged: (val) => setState(() {}),
            decoration: InputDecoration(
              labelText: "Family / Devotee Name",
              hintText: "e.g. Sharma Parivar, Gupta Family",
              prefixIcon: const Icon(Icons.family_restroom, color: AppTheme.marigold),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDark ? AppTheme.templeCardDark : Colors.grey[50],
            ),
          ),

          const SizedBox(height: 20),

          // 9. WATERMARK TOGGLE / REWARDED AD REMOVAL
          if (!isPro)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.sacredMaroon.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.branding_watermark, color: AppTheme.marigold, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Remove watermark for free by watching a short video ad!",
                      style: GoogleFonts.poppins(fontSize: 11.5),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      AdMobService.showRewardedAd(
                        isProUser: isPro,
                        onUserEarnedReward: () {
                          setState(() => _watermarkRemovedThisSession = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Watermark removed for this session! 🎉")),
                          );
                        },
                        onDismissedWithoutReward: () {},
                      );
                    },
                    child: const Text("Watch Ad", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // 10. EXPORT & SHARE BUTTONS
          Row(
            children: [
              // Save 4K
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _exportAndShare4kCard(saveOnly: true),
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text("Save 4K Image", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppTheme.divineGold, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // WhatsApp Share
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _exportAndShare4kCard(saveOnly: false),
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text("WhatsApp Share", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFontChip(String label, int index) {
    final isSelected = _selectedFontFamily == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedFontFamily = index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.sacredMaroon : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.divineGold : Colors.grey.withValues(alpha: 0.4),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
