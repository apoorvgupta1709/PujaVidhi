import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTheme {
  static const Color primaryMaroon = Color(0xFF6B1115);
  static const Color accentGold = Color(0xFFFFB300);
  static const Color backgroundLight = Color(0xFFF9F9FB);
  static const Color cardSurface = Colors.white;
  static const Color sidebarColor = Color(0xFF1E0608);
  static const Color textMain = Color(0xFF212121);
  static const Color textMuted = Color(0xFF757575);

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryMaroon,
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryMaroon,
      foregroundColor: accentGold,
      elevation: 1,
      titleTextStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: accentGold),
    ),
    cardTheme: CardThemeData(
      color: cardSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: textMain),
      titleMedium: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: textMain),
      bodyMedium: GoogleFonts.poppins(fontSize: 13, color: textMain),
    ),
  );
}
