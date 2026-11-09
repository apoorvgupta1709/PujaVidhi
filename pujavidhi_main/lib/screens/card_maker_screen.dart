import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/app_theme.dart';
import '../providers/app_provider.dart';
import '../services/admob_service.dart';

class CardMakerScreen extends StatefulWidget {
  const CardMakerScreen({super.key});

  @override
  State<CardMakerScreen> createState() => _CardMakerScreenState();
}

class _CardMakerScreenState extends State<CardMakerScreen> {
  final GlobalKey _cardKey = GlobalKey();
  final TextEditingController _familyController = TextEditingController();
  String _selectedFestival = "Shubh Deepawali";
  String _selectedWish = "May the divine light of Maha Lakshmi bring health, wealth, and infinite happiness.";
  int _selectedThemeIndex = 0;
  bool _watermarkRemovedThisSession = false;

  final List<Map<String, dynamic>> _themes = [
    {
      "name": "Sacred Crimson",
      "colors": [const Color(0xFF7E191B), const Color(0xFF38080A)],
      "accent": const Color(0xFFFFB300),
      "textColor": Colors.white,
    },
    {
      "name": "Marigold Gold",
      "colors": [const Color(0xFFE65100), const Color(0xFFBF360C)],
      "accent": const Color(0xFFFFE082),
      "textColor": Colors.white,
    },
    {
      "name": "Devotional Indigo",
      "colors": [const Color(0xFF1A237E), const Color(0xFF0D1642)],
      "accent": const Color(0xFFFFD54F),
      "textColor": Colors.white,
    },
    {
      "name": "Vedic Saffron",
      "colors": [const Color(0xFFF57C00), const Color(0xFFD84315)],
      "accent": Colors.white,
      "textColor": Colors.white,
    },
  ];

  final List<Map<String, String>> _festivalGreetings = [
    {
      "festival": "Shubh Deepawali",
      "wish": "May the divine light of Maha Lakshmi bring health, wealth, and infinite happiness to your home.",
    },
    {
      "festival": "Chhath Mahaparva",
      "wish": "May Surya Bhagwan and Chhathi Maiya shower divine vitality, longevity, and purity upon you.",
    },
    {
      "festival": "Shubh Pongal & Makar Sankranti",
      "wish": "Wishing you an abundant harvest season filled with warmth, sweet Pongal, and sunlit prosperity.",
    },
    {
      "festival": "Maha Shivratri",
      "wish": "May Lord Bholenath remove all obstacles and bestow inner stillness and spiritual liberation.",
    },
    {
      "festival": "Jai Shri Ram",
      "wish": "May the supreme virtues and righteousness of Prabhu Shri Ram illuminate every path you walk.",
    },
  ];

  @override
  void initState() {
    super.initState();
    final appProv = Provider.of<AppProvider>(context, listen: false);
    _familyController.text = appProv.familyName;
  }

  @override
  void dispose() {
    _familyController.dispose();
    super.dispose();
  }

  Future<void> _shareCard(bool isProUser) async {
    try {
      final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/devotional_greeting_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(file.path)],
        text: "$_selectedFestival Greetings - ${_familyController.text}\nShared via PujaVidhi App",
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error sharing card: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);
    final isPro = appProv.isProUser || _watermarkRemovedThisSession;
    final activeTheme = _themes[_selectedThemeIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Festival Card Maker"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Preview Card wrapped in RepaintBoundary
            Center(
              child: RepaintBoundary(
                key: _cardKey,
                child: Container(
                  width: 320,
                  height: 380,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: activeTheme["colors"] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: activeTheme["accent"] as Color,
                      width: 2.5,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header Motif
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.wb_sunny_outlined, color: activeTheme["accent"] as Color, size: 24),
                          Text(
                            "॥ ॐ ॥",
                            style: GoogleFonts.poppins(
                              color: activeTheme["accent"] as Color,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.auto_awesome, color: activeTheme["accent"] as Color, size: 24),
                        ],
                      ),

                      // Greetings Text
                      Column(
                        children: [
                          Text(
                            _selectedFestival,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: activeTheme["accent"] as Color,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _selectedWish,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: activeTheme["textColor"] as Color,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),

                      // Family Name & Watermark
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: (activeTheme["accent"] as Color).withValues(alpha: 0.6)),
                            ),
                            child: Text(
                              "From: ${_familyController.text.trim().isEmpty ? 'Sharma Family' : _familyController.text.trim()}",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: activeTheme["accent"] as Color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (!isPro)
                            Text(
                              "Created with PujaVidhi App",
                              style: GoogleFonts.poppins(fontSize: 9, color: Colors.white54),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Family Name Customizer
            Text(
              "Personalize Family Name",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _familyController,
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

            const SizedBox(height: 20),

            // Festival Selector
            Text(
              "Select Festival / Occasion",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _festivalGreetings.map((fg) {
                  final isSelected = fg["festival"] == _selectedFestival;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(fg["festival"]!),
                      selected: isSelected,
                      selectedColor: AppTheme.divineGold.withValues(alpha: 0.3),
                      onSelected: (_) {
                        setState(() {
                          _selectedFestival = fg["festival"]!;
                          _selectedWish = fg["wish"]!;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Theme Selector
            Text(
              "Color Theme",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(_themes.length, (idx) {
                final th = _themes[idx];
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
                        width: 3,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Watermark Removal Banner for Free Users (Rewarded Ad)
            if (!isPro)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.divineGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppTheme.marigold),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Watch a quick ad to remove watermark for this card export!",
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        AdMobService.showRewardedAd(
                          isProUser: appProv.isProUser,
                          onUserEarnedReward: () {
                            setState(() {
                              _watermarkRemovedThisSession = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("✨ Watermark removed for this card!")),
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

            // Share to WhatsApp / Instagram Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => _shareCard(isPro),
                icon: const Icon(Icons.share_rounded, color: AppTheme.divineGold),
                label: Text(
                  "Share on WhatsApp & Instagram",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
