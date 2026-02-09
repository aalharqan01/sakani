import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  static TextTheme get arabicTextTheme => TextTheme(
        displayLarge: GoogleFonts.notoKufiArabic(
            fontSize: 57, fontWeight: FontWeight.w400),
        displayMedium: GoogleFonts.notoKufiArabic(
            fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: GoogleFonts.notoKufiArabic(
            fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: GoogleFonts.notoKufiArabic(
            fontSize: 32, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.notoKufiArabic(
            fontSize: 28, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.notoKufiArabic(
            fontSize: 24, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.notoKufiArabic(
            fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: GoogleFonts.notoKufiArabic(
            fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.notoKufiArabic(
            fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.notoKufiArabic(
            fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.notoKufiArabic(
            fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: GoogleFonts.notoKufiArabic(
            fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.notoKufiArabic(
            fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.notoKufiArabic(
            fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.notoKufiArabic(
            fontSize: 11, fontWeight: FontWeight.w500),
      );

  static TextTheme get englishTextTheme => TextTheme(
        displayLarge:
            GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.w400),
        displayMedium:
            GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall:
            GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge:
            GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w600),
        headlineMedium:
            GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600),
        headlineSmall:
            GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600),
        titleLarge:
            GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium:
            GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall:
            GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge:
            GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium:
            GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall:
            GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge:
            GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium:
            GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall:
            GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
      );
}
