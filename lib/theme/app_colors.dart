import 'package:flutter/material.dart';

/// ALLSELL Color System — Rooted in Commercial Psychology & Ethiopian Aesthetics
/// Primary Amber (#FF8D00): Prosperity, value velocity, dynamism, warmth
/// Obsidian Black (#0B0E14): Authority, institutional trust, architectural luxury
/// Cashmere Cream (#F9F8F5): Editorial warmth, relaxed readability, premium feel
/// Verified Green (#10B981) & Gold (#D97706): Certified KYC, authenticity, trust
class AppColors {
  // --- Core Brand Identity ---
  static const Color primaryAmber = Color(0xFFFF8D00); // Official AllSell Amber
  static const Color primaryAmberDark = Color(0xFFE07700); // Deep rich amber
  static const Color primaryAmberLight = Color(0xFFFFF4E5); // Soft warm amber highlight
  static const Color amberGlow = Color(0x33FF8D00); // Ambient glow

  static const Color obsidianBlack = Color(0xFF0B0E14); // Ultra-deep obsidian
  static const Color charcoalDark = Color(0xFF141923); // Elevated dark surface
  static const Color charcoalCard = Color(0xFF1B2230); // Dark card container
  static const Color charcoalBorder = Color(0xFF283347); // Dark divider

  // --- Editorial Warm Cashmere (Light Theme) ---
  static const Color cashmereBg = Color(0xFFF9F8F5); // Premium warm off-white
  static const Color cashmereSurface = Color(0xFFFFFFFF); // Pure white card surface
  static const Color cashmereElevated = Color(0xFFF3EFE6); // Tinted warm section fill
  static const Color cashmereBorder = Color(0xFFE6E2D8); // Subtle structural border
  static const Color cashmereBorderSubtle = Color(0xFFF0ECE3);

  // --- Text Hierarchies ---
  // Light Mode
  static const Color textDarkPrimary = Color(0xFF0F172A); // High contrast headings
  static const Color textDarkSecondary = Color(0xFF475569); // Informative body
  static const Color textDarkMuted = Color(0xFF8C98A9); // Badges, dates, units

  // Dark Mode
  static const Color textLightPrimary = Color(0xFFF8FAFC);
  static const Color textLightSecondary = Color(0xFF94A3B8);
  static const Color textLightMuted = Color(0xFF64748B);

  // --- Trust, Status & Verification ---
  static const Color verifiedGreen = Color(0xFF10B981); // Emerald trustmark
  static const Color verifiedGreenLight = Color(0xFFD1FAE5);
  static const Color verifiedGold = Color(0xFFD97706); // Ethiopian Gold badge
  static const Color verifiedGoldLight = Color(0xFFFEF3C7);
  static const Color tagForSale = Color(0xFF2563EB); // Royal Blue
  static const Color tagForRent = Color(0xFF7C3AED); // Regal Purple
  static const Color errorRed = Color(0xFFEF4444);
  static const Color alertWarning = Color(0xFFF59E0B);

  // --- Ethiopian Payment Provider Tones ---
  static const Color telebirrBlue = Color(0xFF005BAC);
  static const Color cbePurple = Color(0xFF6B1D73);

  // --- Premium Gradients ---
  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFFF991A), Color(0xFFFF7700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroBannerGradient = LinearGradient(
    colors: [Color(0xFF2A1504), Color(0xFF5C2C07), Color(0xFF994703)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1B2230), Color(0xFF141923)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldBadgeGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
