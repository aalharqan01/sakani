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
            fontSize: 32, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.notoKufiArabic(
            fontSize: 28, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.notoKufiArabic(
            fontSize: 24, fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.notoKufiArabic(
            fontSize: 22, fontWeight: FontWeight.w600),
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
        displayLarge: GoogleFonts.plusJakartaSans(
            fontSize: 57, fontWeight: FontWeight.w400),
        displayMedium: GoogleFonts.plusJakartaSans(
            fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: GoogleFonts.plusJakartaSans(
            fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: GoogleFonts.plusJakartaSans(
            fontSize: 32, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.plusJakartaSans(
            fontSize: 28, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.plusJakartaSans(
            fontSize: 24, fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.plusJakartaSans(
            fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.plusJakartaSans(
            fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.plusJakartaSans(
            fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.plusJakartaSans(
            fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.plusJakartaSans(
            fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: GoogleFonts.plusJakartaSans(
            fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.plusJakartaSans(
            fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.plusJakartaSans(
            fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.plusJakartaSans(
            fontSize: 11, fontWeight: FontWeight.w500),
      );
}
