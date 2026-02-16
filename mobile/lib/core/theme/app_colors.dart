import 'package:flutter/material.dart';

abstract class AppColors {
  // === Brand Colors (Indigo colorway from sakani_indigo.html) ===
  static const primarySeed = Color(0xFF818CF8); // Indigo
  static const primaryDark = Color(0xFF6366F1);
  static const primaryLight = Color(0xFFA5B4FC);
  static const primarySurface = Color(0xFFEEF2FF);

  static const secondarySeed = Color(0xFF818CF8); // Indigo (replaces gold)
  static const goldLight = Color(0xFFA5B4FC);
  static const goldSurface = Color(0xFFEEF2FF);

  static const navy = Color(0xFF1E1B4B);
  static const navyLight = Color(0xFF312E81);

  static const cream = Color(0xFFF8F9FC);
  static const creamDark = Color(0xFFEEEEF5);

  static const surface = Color(0xFFFFFFFF);

  // === Text Colors ===
  static const textPrimary = Color(0xFF1E1B4B);
  static const textSecondary = Color(0xFF64648C);
  static const textMuted = Color(0xFF94A3B8);

  // === Border Colors ===
  static const border = Color(0xFFE2E4ED);
  static const borderLight = Color(0xFFEEEEF5);

  // === Semantic Colors ===
  static const success = Color(0xFF22C55E);
  static const successSurface = Color(0xFFDCFCE7);
  static const warning = Color(0xFFF59E0B);
  static const warningSurface = Color(0xFFFEF3C7);
  static const error = Color(0xFFEF4444);
  static const errorSurface = Color(0xFFFEE2E2);
  static const info = Color(0xFF1565C0);

  // === Cheque Status Colors ===
  static const chequePending = Color(0xFF818CF8); // indigo
  static const chequeDeposited = Color(0xFF42A5F5); // blue
  static const chequeCleared = Color(0xFF22C55E); // green
  static const chequeBounced = Color(0xFFEF4444); // red
  static const chequeUpcoming = Color(0xFF6366F1); // indigo-dark
  static const chequeReplaced = Color(0xFF78909C); // gray

  // === Maintenance Urgency Colors ===
  static const urgencyRoutine = Color(0xFF22C55E);
  static const urgencyUrgent = Color(0xFFF59E0B);
  static const urgencyEmergency = Color(0xFFEF4444);

  // === Category Icon Colors ===
  static const catBlue = Color(0xFF2563EB);
  static const catBlueSurface = Color(0xFFDBEAFE);
  static const catIndigo = Color(0xFF4F46E5);
  static const catIndigoSurface = Color(0xFFE0E7FF);
  static const catAmber = Color(0xFFD97706);
  static const catAmberSurface = Color(0xFFFEF3C7);
  static const catPurple = Color(0xFF7C3AED);
  static const catPurpleSurface = Color(0xFFEDE9FE);
}
