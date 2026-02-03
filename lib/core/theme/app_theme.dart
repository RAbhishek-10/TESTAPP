import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Modern Professional Color Palette (Tailwind-inspired) ---
  static const Color primaryBlue = Color(0xFF2563EB); // Modern Blue
  static const Color secondaryOrange = Color(0xFFF59E0B); // Amber / Gurukul accent
  static const Color primaryOrange = Color(0xFFF59E0B); // Alias for accent/CTA
  static const Color accentIndigo = Color(0xFF4F46E5); // Indigo
  static const Color gurukulSaffron = Color(0xFFEA580C); // Warm CTA highlight

  static const Color bgLight = Color(0xFFF8FAFC); // Slate 50
  static const Color bgCream = Color(0xFFFEFCE8); // Soft cream (Gurukul optional)
  static const Color textDark = Color(0xFF0F172A); // Slate 900
  static const Color textGrey = Color(0xFF64748B); // Slate 500

  static const Color cardShadow = Color(0x0F000000); // Very subtle shadow

  // Reusable card style: radius 20-24, soft shadow, light border
  static const double cardRadius = 20.0;
  static const double cardRadiusLarge = 24.0;
  static const double buttonRadius = 16.0;
  static const double navBarElevation = 0.0;

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Theme Data ---
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: secondaryOrange,
      surface: Colors.white,
      background: bgLight,
    ),
    scaffoldBackgroundColor: bgLight,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    textTheme: GoogleFonts.interTextTheme(), // Inter is more professional for apps
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: textDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        color: textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryBlue,
      unselectedItemColor: textGrey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: navBarElevation,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgLight,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: textGrey.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: GoogleFonts.inter(color: textGrey),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return primaryBlue;
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
      primary: primaryBlue,
      secondary: secondaryOrange,
      surface: const Color(0xFF0F172A),
      background: const Color(0xFF020617),
    ),
    scaffoldBackgroundColor: const Color(0xFF020617),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0F172A),
      selectedItemColor: primaryBlue,
      unselectedItemColor: Color(0xFF94A3B8), // Slate 400
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );

  // --- Common UI Components Helpers ---
  static BoxDecoration glassBox = BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withOpacity(0.2)),
  );

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Softer shadow for cards (modern flat look).
  static List<BoxShadow> cardShadowList = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 16,
      offset: const Offset(0, 2),
    ),
  ];

  /// Section/card decoration (white, rounded 20-24, soft shadow, optional border).
  static BoxDecoration sectionCardDecoration({bool withBorder = true}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(cardRadiusLarge),
      boxShadow: cardShadowList,
      border: withBorder ? Border.all(color: textGrey.withOpacity(0.08)) : null,
    );
  }

  // --- Typography scale (Inter) ---
  static TextStyle get displayStyle =>
      GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: textDark);
  static TextStyle get titleStyle =>
      GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: textDark);
  static TextStyle get bodyStyle =>
      GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: textDark);
  static TextStyle get captionStyle =>
      GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: textGrey);
}
