import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary: Deep teal (trust, professional, Qatar-appropriate)
  static const primarySeed = Color(0xFF0D7377);

  // Secondary: Warm gold (premium feel, Arabic aesthetic)
  static const secondarySeed = Color(0xFFC69749);

  // Semantic colors
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFF57C00);
  static const error = Color(0xFFC62828);
  static const info = Color(0xFF1565C0);

  // Cheque status colors
  static const chequePending = Color(0xFFFFA726);
  static const chequeDeposited = Color(0xFF42A5F5);
  static const chequeCleared = Color(0xFF66BB6A);
  static const chequeBounced = Color(0xFFEF5350);
  static const chequeReplaced = Color(0xFF78909C);

  // Maintenance urgency colors
  static const urgencyRoutine = Color(0xFF66BB6A);
  static const urgencyUrgent = Color(0xFFFFA726);
  static const urgencyEmergency = Color(0xFFEF5350);
}
