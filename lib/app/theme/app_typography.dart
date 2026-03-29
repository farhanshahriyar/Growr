import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme getTextTheme() {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.normal, height: 1.12),
      displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.normal, height: 1.16),
      displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.normal, height: 1.22),
      headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w600, height: 1.25),
      headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, height: 1.29),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, height: 1.43),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, height: 1.6),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, height: 1.6), // 1.6x height
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, height: 1.33),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, height: 1.45),
    );
  }
}
