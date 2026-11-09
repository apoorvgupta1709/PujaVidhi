import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Sacred Vedic Color Palette
  static const Color sacredMaroon = Color(0xFF7E191B);
  static const Color deepTempleNight = Color(0xFF240608);
  static const Color saffronOrange = Color(0xFFE65100);
  static const Color divineGold = Color(0xFFFFB300);
  static const Color marigold = Color(0xFFFF8F00);
  static const Color warmCream = Color(0xFFFDFBF7);
  static const Color templeCardLight = Color(0xFFFFF9F0);
  static const Color templeCardDark = Color(0xFF381013);
  static const Color textDark = Color(0xFF261214);
  static const Color textLight = Color(0xFFFFF4E0);
  static const Color textMuted = Color(0xFF8A6B6D);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: sacredMaroon,
    scaffoldBackgroundColor: warmCream,
    colorScheme: ColorScheme.light(
      primary: sacredMaroon,
      secondary: marigold,
      tertiary: divineGold,
      surface: templeCardLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: sacredMaroon,
      foregroundColor: divineGold,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: divineGold,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: divineGold),
    ),
    cardTheme: CardThemeData(
      color: templeCardLight,
      elevation: 2,
      shadowColor: sacredMaroon.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: divineGold.withValues(alpha: 0.3), width: 1),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: textDark),
      headlineMedium: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
      titleLarge: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: textDark),
      bodyLarge: GoogleFonts.poppins(fontSize: 15, color: textDark),
      bodyMedium: GoogleFonts.poppins(fontSize: 13, color: textDark),
      labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: sacredMaroon,
        foregroundColor: divineGold,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: divineGold, width: 1),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: divineGold,
    scaffoldBackgroundColor: deepTempleNight,
    colorScheme: ColorScheme.dark(
      primary: divineGold,
      secondary: saffronOrange,
      tertiary: marigold,
      surface: templeCardDark,
      onPrimary: deepTempleNight,
      onSecondary: Colors.white,
      onSurface: textLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: templeCardDark,
      foregroundColor: divineGold,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: divineGold,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: divineGold),
    ),
    cardTheme: CardThemeData(
      color: templeCardDark,
      elevation: 3,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: divineGold.withValues(alpha: 0.25), width: 1),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: textLight),
      headlineMedium: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: textLight),
      titleLarge: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: textLight),
      bodyLarge: GoogleFonts.poppins(fontSize: 15, color: textLight),
      bodyMedium: GoogleFonts.poppins(fontSize: 13, color: textLight),
      labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: deepTempleNight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: divineGold,
        foregroundColor: deepTempleNight,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}
