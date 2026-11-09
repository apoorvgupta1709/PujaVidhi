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
import '../providers/app_provider.dart';
import '../services/admob_service.dart';
import '../widgets/ad_banner_widget.dart';

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

class WallpaperGalleryScreen extends StatefulWidget {
  final int initialTabIndex;

  const WallpaperGalleryScreen({super.key, this.initialTabIndex = 0});

  @override
  State<WallpaperGalleryScreen> createState() => _WallpaperGalleryScreenState();
}

class _WallpaperGalleryScreenState extends State<WallpaperGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<TempleWallpaperItem> wallpapers = [
    TempleWallpaperItem(
      id: 'ram_mandir',
      templeName: 'Shri Ram Janmabhoomi',
      location: 'Ayodhya Dham, Uttar Pradesh',
      deity: 'Bhagwan Shri Ram',
      shlokaSanskrit: 'मङ्गल भवन अमङ्गल हारी। द्रवहु सुदसरथ अजिर बिहारी॥',
      quoteEnglish:
          'May the divine grace of Maryada Purushottam Shri Ram bring peace and prosperity.',
      gradientColors: [Color(0xFF78350F), Color(0xFFB45309), Color(0xFFF59E0B)],
      iconBadge: '🏹',
    ),
    TempleWallpaperItem(
      id: 'kashi_vishwanath',
      templeName: 'Kashi Vishwanath Dham',
      location: 'Varanasi, Uttar Pradesh',
      deity: 'Lord Shiva (Mahadev)',
      shlokaSanskrit: 'वाराणसी पुरपतेर्विशालनेत्रं, नमामि विश्वनाथं शशिशेखरं च॥',
      quoteEnglish:
          'Om Namah Shivaya. May the eternal light of Kashi dispel all darkness.',
      gradientColors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
      iconBadge: '🔱',
    ),
    TempleWallpaperItem(
      id: 'kedarnath',
      templeName: 'Kedarnath Dham',
      location: 'Garhwal Himalayas, Uttarakhand',
      deity: 'Lord Shiva',
      shlokaSanskrit: 'महाद्रिपार्श्वे च तटे रमन्तं, सम्पूज्यमानं सततं मुनीन्द्रैः॥',
      quoteEnglish:
          'In the lap of snow-clad Himalayas, Mahadev bestows ultimate inner peace.',
      gradientColors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0284C7)],
      iconBadge: '❄️',
    ),
    TempleWallpaperItem(
      id: 'tirupati_balaji',
      templeName: 'Tirumala Venkateswara',
      location: 'Tirupati, Andhra Pradesh',
      deity: 'Lord Venkateswara (Govinda)',
      shlokaSanskrit: 'वेङ्कटाद्रिसमं स्थानं ब्रह्माण्डे नास्ति किञ्चन॥',
      quoteEnglish:
          'Govinda Hari Govinda! May Lord of the Seven Hills grant boundless abundance.',
      gradientColors: [Color(0xFF831843), Color(0xFF9D174D), Color(0xFFBE185D)],
      iconBadge: '🪷',
    ),
    TempleWallpaperItem(
      id: 'siddhivinayak',
      templeName: 'Shri Siddhivinayak Temple',
      location: 'Prabhadevi, Mumbai',
      deity: 'Bhagwan Ganesha',
      shlokaSanskrit: 'वक्रतुण्ड महाकाय सूर्यकोटि समप्रभ। निर्विघ्नं कुरु मे देव॥',
      quoteEnglish:
          'Ganpati Bappa Morya! May all hurdles vanish with Bappa\'s divine blessings.',
      gradientColors: [Color(0xFF7C2D12), Color(0xFFC2410C), Color(0xFFEA580C)],
      iconBadge: '🪔',
    ),
    TempleWallpaperItem(
      id: 'meenakshi_amman',
      templeName: 'Meenakshi Sundareswarar',
      location: 'Madurai, Tamil Nadu',
      deity: 'Mata Meenakshi & Sundareswarar',
      shlokaSanskrit: 'मातर्मधुपुरस्वामिनि भक्तकामप्रदायिनि। नमामि मीनाक्षीं देवीं॥',
      quoteEnglish:
          'Salutations to the divine mother Meenakshi who grants wisdom, strength, and joy.',
      gradientColors: [Color(0xFF14532D), Color(0xFF15803D), Color(0xFF16A34A)],
      iconBadge: '🌺',
    ),
  ];

  // --- STUDIO & BUILDER STATE ---
  final GlobalKey _canvasKey = GlobalKey();
  final TextEditingController _senderCtrl = TextEditingController();
  final TextEditingController _quoteCtrl = TextEditingController();

  // Canvas Format: 0: 9:16 (Phone Wallpaper/Status), 1: 1:1 (Festival Card), 2: 4:5 (Devotional Post)
  int _selectedFormat = 0;

  // Background Theme
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
  String? _godCustomPhotoPath;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
    );

    final appProv = Provider.of<AppProvider>(context, listen: false);
    _senderCtrl.text = appProv.familyName;
    _quoteCtrl.text = _deities[0]["shloka"]!;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _senderCtrl.dispose();
    _quoteCtrl.dispose();
    super.dispose();
  }

  // --- Image Pickers for Custom Photos ---
  Future<void> _pickUserPhoto() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() => _userCustomPhotoPath = file.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Notice: Photo picking cancelled or error: $e")),
        );
      }
    }
  }

  Future<void> _pickGodPhoto() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() => _godCustomPhotoPath = file.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Notice: Deity photo picking cancelled or error: $e")),
        );
      }
    }
  }

  // --- Load Temple into Studio ---
  void _loadWallpaperIntoStudio(TempleWallpaperItem item) {
    setState(() {
      _quoteCtrl.text = "${item.shlokaSanskrit}\n\n\"${item.quoteEnglish}\"";
      // Switch to Studio Tab
      _tabController.animateTo(1);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Loaded '${item.templeName}' into Devotional Studio!"),
        backgroundColor: AppTheme.sacredMaroon,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- High-Resolution 4K Render & Share ---
  Future<void> _exportAndShare(bool isProUser, {bool isDownloadOnly = false}) async {
    try {
      final boundary =
          _canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // 3.5x pixel ratio produces crystal-clear 4K / UHD export
      final image = await boundary.toImage(pixelRatio: 3.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final fileName =
          'pujavidhi_4k_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      if (isDownloadOnly) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✨ 4K Wallpaper saved cleanly to ${file.path}!"),
              backgroundColor: AppTheme.sacredMaroon,
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
        return GoogleFonts.martel(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: color,
          height: 1.5,
        );
      case 1:
        return GoogleFonts.rozhaOne(
          fontSize: size + 2,
          fontWeight: FontWeight.bold,
          color: color,
          height: 1.4,
        );
      case 2:
        return GoogleFonts.poppins(
          fontSize: size,
          fontWeight: FontWeight.w600,
          color: color,
          height: 1.4,
        );
      case 3:
      default:
        return GoogleFonts.cinzel(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: color,
          height: 1.4,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);
    final isPro = appProv.isProUser || _watermarkRemovedThisSession;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          tabs: const [
            Tab(icon: Icon(Icons.photo_library_outlined), text: "4K Wallpapers"),
            Tab(icon: Icon(Icons.brush_rounded), text: "Studio & Card Maker"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ==========================================
          // TAB 1: 4K TEMPLE WALLPAPERS GALLERY
          // ==========================================
          _buildWallpapersGalleryTab(context, appProv, isDark),

          // ==========================================
          // TAB 2: STUDIO & DEVOTIONAL CARD MAKER
          // ==========================================
          _buildStudioTab(context, appProv, isPro, isDark),
        ],
      ),
    );
  }

  // --- TAB 1: WALLPAPER GALLERY ---
  Widget _buildWallpapersGalleryTab(
      BuildContext context, AppProvider appProv, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: isDark ? AppTheme.templeCardDark : Colors.white,
          child: Row(
            children: [
              const Icon(Icons.wb_sunny_rounded, color: AppTheme.marigold, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "High-Resolution Temple Darshans. Tap 'Edit in Studio' to add your photo or custom shlokas!",
                  style: GoogleFonts.poppins(fontSize: 11.5, color: AppTheme.textMuted),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
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
                    // Visual 4K Card Banner
                    Container(
                      height: 185,
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
                          Positioned(
                            right: -25,
                            bottom: -25,
                            child: Text(
                              item.iconBadge,
                              style: const TextStyle(fontSize: 120),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.35),
                                        borderRadius: BorderRadius.circular(12),
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
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
                                      item.templeName,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.location,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 12,
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
                          Text(
                            item.shlokaSanskrit,
                            style: GoogleFonts.martel(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.textLight : AppTheme.sacredMaroon,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\"${item.quoteEnglish}\"",
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontStyle: FontStyle.italic,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          const Divider(height: 20),
                          Row(
                            children: [
                              // Customize in Studio Button
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _loadWallpaperIntoStudio(item),
                                  icon: const Icon(Icons.brush_rounded, size: 16),
                                  label: Text(
                                    "Edit in Studio",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.sacredMaroon,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Quick Share Status
                              IconButton(
                                icon: const Icon(Icons.share_rounded,
                                    color: Color(0xFF25D366)),
                                tooltip: "Share on WhatsApp",
                                onPressed: () {
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
      BuildContext context, AppProvider appProv, bool isPro, bool isDark) {
    final activeTheme = _studioThemes[_selectedThemeIndex];
    final activeDeity = _deities[_selectedDeityIndex];
    final selectedTextColor = _textColors[_selectedColorIndex];

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
                  gradient: LinearGradient(
                    colors: activeTheme["colors"] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: (activeTheme["accent"] as Color)
                                  .withValues(alpha: 0.6),
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
                        // If user uploaded God Photo
                        if (_godCustomPhotoPath != null)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: activeTheme["accent"] as Color,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (activeTheme["accent"] as Color)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 10,
                                ),
                              ],
                              image: DecorationImage(
                                image: FileImage(File(_godCustomPhotoPath!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          // Built-in Deity Emblem
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  activeTheme["accent"] as Color,
                                  (activeTheme["colors"] as List<Color>).first,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                activeDeity["symbol"]!,
                                style: const TextStyle(fontSize: 36),
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          activeDeity["name"]!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: activeTheme["accent"] as Color,
                          ),
                        ),
                      ],
                    ),

                    // Middle: Quote / Shloka Overlay
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (activeTheme["accent"] as Color)
                              .withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        _quoteCtrl.text.trim().isEmpty
                            ? activeDeity["shloka"]!
                            : _quoteCtrl.text.trim(),
                        textAlign: TextAlign.center,
                        style: _getSelectedTextStyle(
                            selectedTextColor, _quoteFontSize),
                      ),
                    ),

                    // Bottom Row: Family / User Photo + Name Badge + Watermark
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Optional Custom User Photo Avatar
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (activeTheme["accent"] as Color)
                                      .withValues(alpha: 0.6),
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
                                    color: Colors.white60,
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
              ButtonSegment(
                  value: 0,
                  label: Text("4K Wallpaper (9:16)", style: TextStyle(fontSize: 11.5))),
              ButtonSegment(
                  value: 1,
                  label: Text("Square Card (1:1)", style: TextStyle(fontSize: 11.5))),
              ButtonSegment(
                  value: 2,
                  label: Text("Mandir Post (4:5)", style: TextStyle(fontSize: 11.5))),
            ],
            selected: {_selectedFormat},
            onSelectionChanged: (set) => setState(() => _selectedFormat = set.first),
          ),

          const SizedBox(height: 20),

          // 3. PHOTOS: ADD YOUR PHOTO & GOD PHOTO
          Text(
            "2. Add Photos & Overlays",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // User Photo
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickUserPhoto,
                  icon: Icon(
                    _userCustomPhotoPath != null ? Icons.check_circle : Icons.person_add,
                    color: _userCustomPhotoPath != null ? Colors.green : AppTheme.marigold,
                    size: 18,
                  ),
                  label: Text(
                    _userCustomPhotoPath != null ? "Change My Photo" : "Add Your Photo",
                    style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // God Photo
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickGodPhoto,
                  icon: Icon(
                    _godCustomPhotoPath != null ? Icons.check_circle : Icons.add_photo_alternate,
                    color: _godCustomPhotoPath != null ? Colors.green : AppTheme.divineGold,
                    size: 18,
                  ),
                  label: Text(
                    _godCustomPhotoPath != null ? "Change God Pic" : "Upload God Pic",
                    style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          if (_userCustomPhotoPath != null || _godCustomPhotoPath != null) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_userCustomPhotoPath != null)
                  TextButton.icon(
                    onPressed: () => setState(() => _userCustomPhotoPath = null),
                    icon: const Icon(Icons.close, size: 14, color: Colors.red),
                    label: const Text("Remove My Photo", style: TextStyle(fontSize: 11, color: Colors.red)),
                  ),
                if (_godCustomPhotoPath != null)
                  TextButton.icon(
                    onPressed: () => setState(() => _godCustomPhotoPath = null),
                    icon: const Icon(Icons.close, size: 14, color: Colors.red),
                    label: const Text("Reset Deity", style: TextStyle(fontSize: 11, color: Colors.red)),
                  ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // 4. DEITY SELECTION
          Text(
            "3. Select Deity (इष्टदेव)",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _deities.length,
              itemBuilder: (context, idx) {
                final d = _deities[idx];
                final isSelected = idx == _selectedDeityIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text("${d["symbol"]} ${d["name"]}"),
                    selected: isSelected,
                    selectedColor: AppTheme.sacredMaroon,
                    labelStyle: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedDeityIndex = idx;
                        _godCustomPhotoPath = null;
                        _quoteCtrl.text = d["shloka"]!;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // 5. COLOR THEMES
          Text(
            "4. Sacred Color Theme",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_studioThemes.length, (idx) {
              final th = _studioThemes[idx];
              final isSelected = idx == _selectedThemeIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedThemeIndex = idx),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: th["colors"] as List<Color>),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppTheme.divineGold : Colors.transparent,
                      width: 3.5,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppTheme.divineGold.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // 6. QUOTE & SHLOKA OVERLAYS
          Text(
            "5. Quote / Shloka Overlay",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          // Preset selector
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _presetQuotes.length,
              itemBuilder: (context, idx) {
                final p = _presetQuotes[idx];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(p["title"]!, style: const TextStyle(fontSize: 11)),
                    onPressed: () {
                      setState(() => _quoteCtrl.text = p["text"]!);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _quoteCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Type custom shloka, prayer, or greeting...",
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onChanged: (val) => setState(() {}),
          ),

          const SizedBox(height: 14),

          // Font controls
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Font Style", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownButton<int>(
                      value: _selectedFontFamily,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 0, child: Text("Martel (Vedic)")),
                        DropdownMenuItem(value: 1, child: Text("Rozha One (Bold)")),
                        DropdownMenuItem(value: 2, child: Text("Poppins (Modern)")),
                        DropdownMenuItem(value: 3, child: Text("Cinzel (Classic)")),
                      ],
                      onChanged: (v) => setState(() => _selectedFontFamily = v ?? 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Font Size: ${_quoteFontSize.toInt()}", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                    Slider(
                      min: 11,
                      max: 22,
                      value: _quoteFontSize,
                      activeColor: AppTheme.sacredMaroon,
                      onChanged: (v) => setState(() => _quoteFontSize = v),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Text Color Picker
          Row(
            children: [
              Text("Text Color:", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              ..._textColors.asMap().entries.map((entry) {
                final idx = entry.key;
                final col = entry.value;
                final isSel = idx == _selectedColorIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = idx),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: col,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSel ? AppTheme.sacredMaroon : Colors.grey,
                        width: 2.5,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 20),

          // 7. SENDER / FAMILY NAME
          Text(
            "6. Family / Sender Name",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _senderCtrl,
            decoration: InputDecoration(
              hintText: "e.g. Sharma Family / शर्मा परिवार",
              prefixIcon: const Icon(Icons.family_restroom, color: AppTheme.marigold),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onChanged: (val) {
              appProv.setFamilyName(val);
              setState(() {});
            },
          ),

          const SizedBox(height: 24),

          // Watermark Removal Banner for Free Users (Rewarded Ad)
          if (!isPro)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.divineGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppTheme.marigold),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Watch a quick ad to remove watermark for this 4K export!",
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      AdMobService.showRewardedAd(
                        isProUser: appProv.isProUser,
                        onUserEarnedReward: () {
                          setState(() => _watermarkRemovedThisSession = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("✨ Watermark removed for this 4K export!")),
                          );
                        },
                        onDismissedWithoutReward: () {},
                      );
                    },
                    child: const Text("Unlock"),
                  ),
                ],
              ),
            ),

          // EXPORT BUTTONS: 1-Tap WhatsApp Share & 4K Download
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _exportAndShare(isPro),
                    icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                    label: Text(
                      "Share on WhatsApp",
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _exportAndShare(isPro, isDownloadOnly: true),
                    icon: const Icon(Icons.download_rounded, color: AppTheme.sacredMaroon, size: 20),
                    label: Text(
                      "Save 4K",
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.divineGold,
                      foregroundColor: AppTheme.sacredMaroon,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const AdBannerWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
