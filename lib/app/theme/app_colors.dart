import 'package:flutter/material.dart';

class AppColors {
  // Primary & Accent Colors
  static const Color primary = Color(0xFFD63031);
  static const Color primaryDark = Color(0xFFBD1112);
  static const Color primaryLight = Color(0xFFA29BFE);
  
  static const Color secondary = Color(0xFFFF7675);
  static const Color secondaryDark = Color(0xFFD63031);
  
  static const Color accent = Color(0xFF00CEC9);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFFF4757);

  // Neutral Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textHint = Color(0xFFB2BEC3);
  static const Color textLight = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF8E44AD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFF0984E3), Color(0xFF6C5CE7)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Shimmer
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
